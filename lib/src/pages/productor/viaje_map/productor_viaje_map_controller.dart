import 'dart:async';
import 'package:local/src/widgets/bottom_sheet_productor_info.dart';
import 'package:location/location.dart' as location;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/api/environment.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/models/travel_info.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/geofire_provider.dart';
import 'package:local/src/providers/push_notifications_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/providers/travel_info_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProductorViajeMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(-0.2508395, -78.5210313),
      zoom: 14.0
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeoFireProvider _geofireProvider;
  AuthProvider _authProvider;
  RecicladorProvider _recicladorProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  bool isConnect = false;
  ProgressDialog _progressDialog;
  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _recicladorInfoSuscription;
  StreamSubscription<DocumentSnapshot> _streamLocationController;
  Set<Polyline> polylines = {};
  List<LatLng> points = [];
  Reciclador reciclador;
  LatLng _recicladorLatLng;
  TravelInfo travelInfo;
  bool isRouteReady = false;
  String currentStatus = '';
  Color colorStatus = Colors.white;
  bool isPickupTravel = false;
  bool isStartTravel = false;
  bool isFinishTravel = false;

  StreamSubscription<DocumentSnapshot> _streamTravelController;


  Future init(BuildContext context, Function refresh) async {

    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _recicladorProvider = new RecicladorProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/auto.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    checkGPS();
  }
  void getRecicladorLocation(String id) {
    Stream<DocumentSnapshot> stream = _geofireProvider.getLocationByIdStream(id);
    _streamLocationController = stream.listen((DocumentSnapshot document) {
      GeoPoint geoPoint = document.data()['position']['geopoint'];
      _recicladorLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker(
          'reciclador',
          _recicladorLatLng.latitude,
          _recicladorLatLng.longitude,
          'Tu conductor',
          '',
          markerDriver
      );

      refresh();

      if (!isRouteReady) {
        isRouteReady = true;
        checkTravelStatus();
      }

    });
  }
  void pickupTravel() {
    if (!isPickupTravel) {
      isPickupTravel = true;
    LatLng from = new LatLng(_recicladorLatLng.latitude, _recicladorLatLng.longitude);
    LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
    addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
    setPolylines(from, to);
    }
  }

  void checkTravelStatus() async {
    Stream<DocumentSnapshot> stream = _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamTravelController = stream.listen((DocumentSnapshot document) {
      travelInfo = TravelInfo.fromJson(document.data());

      if (travelInfo.status == 'accepted') {
        currentStatus = 'Aceptado';
        colorStatus = Colors.white;
        pickupTravel();
      }
      else if (travelInfo.status == 'started') {
        currentStatus = 'Iniciado';
        colorStatus = Colors.amber;
      }
      else if (travelInfo.status == 'finished') {
        currentStatus = 'Finalizado';
        colorStatus = Colors.cyan;
        finishTravel();
      }

      refresh();

    });
  }
  void openBottomSheet() {
    if (reciclador == null) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetProductorInfo(
          imageUrl: reciclador.image,
          username: reciclador.username,
          email: reciclador.email,
          plate: reciclador.plate,
          mobile: reciclador.mobile,
        )
    );
  }
  void finishTravel() {
    if (!isFinishTravel) {
      isFinishTravel = true;
      Navigator.pushNamedAndRemoveUntil(context, 'productor/travel/calification', (route) => false, arguments: travelInfo.idTravelHistory);
    }
  }
  void startTravel() {
    if (!isStartTravel) {
      isStartTravel = true;
      polylines = {};
      points = [];
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      addSimpleMarker(
          'to',
          travelInfo.toLat,
          travelInfo.toLng,
          'Destino',
          '',
          toMarker
      );

      LatLng from = new LatLng(_recicladorLatLng.latitude, _recicladorLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      refresh();
    }
  }

  void _getTravelInfo() async {
    travelInfo = (await _travelInfoProvider.getById(_authProvider.getUser().uid));
    animateCameraToPosition(travelInfo.fromLat, travelInfo.fromLng);
    getDriverInfo(travelInfo.idDriver);
    getRecicladorLocation(travelInfo.idDriver);
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

    //addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
    // addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();
  }
  void getDriverInfo(String id) async {
    reciclador = await _recicladorProvider.getById(id);
    refresh();
  }

  void dispose() {
    _statusSuscription.cancel();
    _recicladorInfoSuscription.cancel();
    _streamLocationController.cancel();
    _streamTravelController.cancel();
  }
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
    _getTravelInfo();
  }
  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        print('ACTIVO EL GPS');
      }
    }

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