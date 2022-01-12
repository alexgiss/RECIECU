import 'dart:async';
import 'package:local/src/api/environment.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/models/travel_info.dart';
import 'package:local/src/providers/push_notifications_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/geofire_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_google_places/flutter_google_places.dart';
class ProductorMapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController= Completer();
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(-0.2508395, -78.5210313),
      zoom: 14.0
  );
  Map<MarkerId, Marker> markers= <MarkerId, Marker>{};
  Position _position;
  StreamSubscription<Position> _positionStream;
  BitmapDescriptor markerReciclador;
  GeoFireProvider _geoFireProvider;
  AuthProvider _authProvider;
  bool isConnect = false;
  ProgressDialog _progressDialog;
  ProductorProvider _productorProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _productorInfoSuscription;


  Productor productor = new Productor(id: 'id', username: 'username', email: 'email', mobile: 'mobile', password: 'password');
  //Productor productor;
  String from;
  LatLng fromLatLng;
  String to;
  LatLng toLatLng;
  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(apiKey: Environment.API_KEY_MAPS);
  bool isFromSelected = true;


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _geoFireProvider = new GeoFireProvider();
    _authProvider = new AuthProvider();
    _productorProvider = new ProductorProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectándose ...');
    markerReciclador = await createMarkerImageFromAsset('assets/img/auto.png');
    checkGPS();
    saveToken();
    getProductorInfo();
  }

  void getProductorInfo(){
    Stream<DocumentSnapshot> productorStream = _productorProvider.getByIdStream(_authProvider.getUser().uid);
    _productorInfoSuscription=productorStream.listen((DocumentSnapshot document) {
      productor = Productor.fromJson(document.data());
      refresh();
    });
  }


  void openDrawer(){
    key.currentState.openDrawer();
  }
  void dispose() async{
    _statusSuscription?.cancel();
    _productorInfoSuscription?.cancel();
    _positionStream?.cancel();


  }

  void signOut() async{
    await _authProvider.sigOut();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async{
    try{
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      centerPosition();
      getNearbyProductor();
    }catch(error){
      print('Error en la Localización $error' );
    }
  }
  void requestViaje(){
    if(fromLatLng != null && toLatLng != null){
      Navigator.pushNamed(context, 'productor/ingresop', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
      });
    }else{
      utils.Snackbar.showSnackbar(context, key, 'Coloque las calles de recogida de los productos');
    }

  }
  void changeFromTO() {
    isFromSelected = !isFromSelected;

    if (isFromSelected) {
      utils.Snackbar.showSnackbar(context, key, 'Estas seleccionando calle principal');
    }
    else {
      utils.Snackbar.showSnackbar(context, key, 'Estas seleccionando calle transversal');
    }

  }
  Future<Null> showGoogleAutoComplete(bool isFrom) async{
    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Environment.API_KEY_MAPS,
        language: 'es',
        strictbounds: true,
        radius: 500000,
        location: places.Location(-0.2701442,-78.5414949)
    );
    if(p != null){
      places.PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId,language: 'es');
      double lat= detail.result.geometry.location.lat;
      double lng=detail.result.geometry.location.lng;
      List<Address> address= await Geocoder.local.findAddressesFromQuery(p.description);
      if(address != null){
        if(address.length >0){
          if(detail != null){
            String direction= detail.result.name;
            String city = address[0].locality;
            String department= address[0].adminArea;
            if (isFrom) {
              from = '$direction, $city, $department';
              fromLatLng = new LatLng(lat, lng);
            }
            else {
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }
            refresh();
          }
        }

      }
    }
  }
  Future<Null> setLocationDraggableInfo() async {
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      if(address != null){
        if(address.length >0 ){
          String direction=address[0].thoroughfare;
          String street=address[0].subThoroughfare;
          String city = address[0].locality;
          String department= address[0].administrativeArea;
          String country = address[0].country;
          if (isFromSelected) {
            from = '$direction #$street, $city, $department, $country';
            fromLatLng = new LatLng(lat, lng);
          }
          else {
            to = '$direction #$street, $city, $department, $country';
            toLatLng = new LatLng(lat, lng);
          }
          refresh();
        }
        
      }
    }
  }
  void goToEditPage(){
    Navigator.pushNamed(context, 'productor/edit');
  }
  void goToHistoryPage(){
    Navigator.pushNamed(context, 'productor/history');
  }
  void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider.getUser().uid, 'productor');

  }

  void getNearbyProductor() {
    Stream<List<DocumentSnapshot>> stream =
    _geoFireProvider.getNearbyProductor(_position.latitude, _position.longitude, 50);

    stream.listen((List<DocumentSnapshot> documentList) {

      for (DocumentSnapshot d in documentList) {
        print('DOCUMENT: $d');
      }

      for(MarkerId m in markers.keys){
        bool remove = true;
        for(DocumentSnapshot d in documentList){
          if(m.value == d.id){
            remove=false;
          }
        }
        if(remove){
          markers.remove(m);
          refresh();
        }
      }
      for (DocumentSnapshot d in documentList){
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(

            d.id,
            point.latitude,
            point.longitude,
            'Reciclador Disponible',
            d.id,
            markerReciclador,

        );

      }

      refresh();
    });
  }
  void centerPosition(){
    if(_position != null){
      animateCameraToPosition(_position.latitude, _position.longitude);
    }else{
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async{
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnable){
      print('GPS Activado');
      updateLocation();
    }else{
      print('GPS Desactivado');
      bool LocationGPS = await location.Location().requestService();
      if(LocationGPS){
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
    if(controller != null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 12
          )
      ));
    }
  }
  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async{
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker,
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker=Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 1,
        anchor: Offset(0.5,0.5),
        rotation: _position.heading,
    );
    markers[id]= marker;
  }
}