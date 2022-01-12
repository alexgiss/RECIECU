import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:local/src/api/environment.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/models/travel_info.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/travel_history_provider.dart';
import 'package:local/src/providers/travel_info_provider.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local/src/widgets/bottom_sheet_reciclador_info.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/geofire_provider.dart';
import 'package:local/src/providers/push_notifications_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RecicladorViajeMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(-0.2508395, -78.5210313),
      zoom: 14.0
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position _position;
  StreamSubscription<Position> _positionStream;
  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;


  GeoFireProvider _geofireProvider;
  AuthProvider _authProvider;
  RecicladorProvider _recicladorProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  ProductorProvider _productorProvider;
  TravelHistoryProvider _travelHistoryProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _recicladorInfoSuscription;
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  Reciclador reciclador;
  Productor _productor;
  String _idTravel;
  TravelInfo travelInfo;
  String currentStatus = 'INICIAR';
  Color colorStatus = Colors.amber;
  double _distanceBetween;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _idTravel=ModalRoute.of(context).settings.arguments as String;
    _geofireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _recicladorProvider = new RecicladorProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _productorProvider = new ProductorProvider();
    _travelHistoryProvider = new TravelHistoryProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/auto.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');
    checkGPS();
    getDriverInfo();
  }
  void getProductorInfo() async {
    _productor = (await _productorProvider.getById(_idTravel));
  }
  void isCloseToPickupPosition(LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    print('------ DISTANCE: $_distanceBetween--------');
  }

  void updateStatus () {
    if (travelInfo.status == 'accepted') {
      startTravel();
    }
    else if (travelInfo.status == 'started') {
      finishTravel();
    }
  }
  void startTravel() async {
   // if (_distanceBetween <= 300) {
      Map<String, dynamic> data = {
        'status': 'started'
      };
      await _travelInfoProvider.update(data, _idTravel);
      travelInfo.status = 'started';
      currentStatus = 'FINALIZAR VIAJE';
      colorStatus = Colors.cyan;

      polylines = {};
      points = [];
      // markers.remove(markers['from']);
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      addSimpleMarker(
          'to',
          travelInfo.toLat,
          travelInfo.toLng,
          'Destino',
          '',
          toMarker
      );

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);

      refresh();
   // }
    //else {
      //utils.Snackbar.showSnackbar(context, key, 'Debes estar cerca a la posicion de recogida del reciclaje');
    //}

    //refresh();
  }

  void finishTravel() async {

    saveTravelHistory();
    //Navigator.pushNamedAndRemoveUntil(context, 'reciclador/viaje/calification', (route) => false,arguments: id);
    //refresh();
  }
  void saveTravelHistory() async {
    TravelHistory travelHistory = new TravelHistory(
        from: travelInfo.from,
        to: travelInfo.to,
        detalle: travelInfo.detalle,
        idReciclador: _authProvider.getUser().uid,
        idProductor: _idTravel,
        timestamp: DateTime.now().millisecondsSinceEpoch,

    );

    String id = await _travelHistoryProvider.create(travelHistory);
    Map<String, dynamic> data = {
      'status': 'finished',
      'idTravelHistory': id,
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = 'finished';

    Navigator.pushNamedAndRemoveUntil(context, 'reciclador/viaje/calification', (route) => false, arguments: id);
  }


  void _getTravelInfo() async{
    travelInfo = (await _travelInfoProvider.getById(_idTravel));
    LatLng from = new LatLng(_position.latitude, _position.longitude);
    LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
    addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
    setPolylines(from, to);
    getProductorInfo();
  }
  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 6
    );

    polylines.add(polyline);

    // addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();
  }

  void getDriverInfo() {
    Stream<DocumentSnapshot> recicladorStream = _recicladorProvider.getByIdStream(_authProvider.getUser().uid);
    _recicladorInfoSuscription = recicladorStream.listen((DocumentSnapshot document) {
      reciclador = Reciclador.fromJson(document.data());
      refresh();
    });
  }

  void dispose() {

    _positionStream.cancel();
    _statusSuscription.cancel();
    _recicladorInfoSuscription.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.createWorking(
        _authProvider.getUser().uid,
        _position.latitude,
        _position.longitude
    );
    _progressDialog.hide();
  }

  void updateLocation() async  {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      _getTravelInfo();
      centerPosition();
      saveLocation();

      addMarker(
          'reciclador',
          _position.latitude,
          _position.longitude,
          'Tu posicion',
          '',
          markerDriver
      );
      refresh();

      _positionStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best,
          distanceFilter: 1
      ).listen((Position position) {
        _position = position;
        addMarker(
            'driver',
            _position.latitude,
            _position.longitude,
            'Tu posicion',
            '',
            markerDriver
        );
        animateCameraToPosition(_position.latitude, _position.longitude);
        if (travelInfo.fromLat != null && travelInfo.fromLng != null) {
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
          isCloseToPickupPosition(from, to);
        }
        saveLocation();
        refresh();
      });

    } catch(error) {
      print('Error en la localizacion: $error');
    }
  }
  void openBottomSheet() {
    if (_productor == null) return;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetRecicladorInfo(
          imageUrl: _productor.image,
          username: _productor.username,
          email: _productor.email,
          mobile: _productor.mobile,
        )
    );
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para obtener la posicion');
    }
  }


  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
      updateLocation();
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('ACTIVO EL GPS');
      }
    }

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 17
          )
      ));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading
    );

    markers[id] = marker;

  }
  void addSimpleMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),

    );

    markers[id] = marker;

  }


}