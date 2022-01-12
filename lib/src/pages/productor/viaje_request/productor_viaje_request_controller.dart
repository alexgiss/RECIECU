import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/models/travel_info.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/push_notifications_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/providers/geofire_provider.dart';
import 'package:local/src/providers/travel_info_provider.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
class ProductorViajeRequestController{
  BuildContext context;
  Function refresh;
  String from;
  String to;
  String detalle;
  LatLng fromLatLng;
  LatLng toLatLng;

  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  RecicladorProvider _recicladorProvider;
  GeoFireProvider _geofireProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  List<String> nearbyDrivers = [];


  StreamSubscription<List<DocumentSnapshot>> _streamSubscription;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _recicladorProvider = new RecicladorProvider();
    _geofireProvider = new GeoFireProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();


    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    detalle = arguments['detalle'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
    _getNearbyRecicladores();

  }
  void _checkRecicladorResponse(){
    Stream<DocumentSnapshot> stream= _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamStatusSubscription=stream.listen((DocumentSnapshot document) {
      TravelInfo travelInfo= TravelInfo.fromJson(document.data());
      if(travelInfo.idDriver != null && travelInfo.status=='accepted'){
       Navigator.pushNamedAndRemoveUntil(context, 'productor/viaje/map', (route) => false);
        //Navigator.pushReplacementNamed(context, 'productor/viaje/map');
      }else if(travelInfo.status=='no_accepted'){
        utils.Snackbar.showSnackbar(context, key, 'El reciclador no acepto tu solicitud');
        Future.delayed(Duration(milliseconds: 4000),(){
          Navigator.pushNamedAndRemoveUntil(context, 'productor/map', (route) => false);
        });
      }
    });
  }
  void dispose () {
    _streamSubscription.cancel();
    _streamStatusSubscription.cancel();
  }

  void _getNearbyRecicladores() async {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyProductor(
        fromLatLng.latitude,
        fromLatLng.longitude,
        5
    );

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('RECICLADOR ENCONTRADO ${d.id}');
        nearbyDrivers.add(d.id);
      }
      getRecicladorInfo(nearbyDrivers[0]);
      _streamSubscription.cancel();
    });
  }
  void _createTravelInfo() async {
    TravelInfo travelInfo = new TravelInfo(
        id: _authProvider.getUser().uid,
        from: from,
        to: to,
        detalle: detalle,
        fromLat: fromLatLng.latitude,
        fromLng: fromLatLng.longitude,
        toLat: toLatLng.latitude,
        toLng: toLatLng.longitude,
        status: 'created'
    );

    await _travelInfoProvider.create(travelInfo);
    _checkRecicladorResponse();
  }
  Future<void> getRecicladorInfo(String idDriver) async {
    Reciclador reciclador = await _recicladorProvider.getById(idDriver);
    _sendNotification(reciclador.token);
  }

  void _sendNotification(String token) {
    print('TOKEN: $token');

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'idProductor': _authProvider.getUser().uid,
      'origin': from,
      'destination': to,
      'oferta':detalle,
    };
    _pushNotificationsProvider.sendMessage(token, data, 'Solicitud de servicio', 'Un productor esta solicitando retiro de productos reciclados');
  }

}
