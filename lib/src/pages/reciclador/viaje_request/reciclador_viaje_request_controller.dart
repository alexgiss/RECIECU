import 'package:flutter/material.dart';
import 'dart:async';
import 'package:local/src/models/productor.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/geofire_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/travel_info_provider.dart';
import 'package:local/src/utils/shared_pref.dart';


class RecicladorViajeRequestController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;
  SharedPref _sharedPref;
  String from;
  String to;
  String detalle;
  String idProductor;
  Productor productor;
  ProductorProvider _productorProvider;
  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  GeoFireProvider _geoFireProvider;
  Timer _timer;
  int seconds=30;

  Future init (BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save('isNotification', 'false');
    _productorProvider = new ProductorProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _geoFireProvider= new GeoFireProvider();
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print('Arguments: $arguments');

    from = arguments['origin'];
    to = arguments['destination'];
    detalle = arguments['oferta'];
    idProductor = arguments['idProductor'];
    getRecicladorInfo();
    startTimer();
  }
  void dispose(){
    _timer.cancel();
  }
  void startTimer(){
    _timer= Timer.periodic(Duration(seconds: 1), (timer) {
      seconds=seconds-1;
      refresh();
      if(seconds == 0){
        cancelTravel();
      }
    });
  }
  void acceptTravel() {
    Map<String, dynamic> data = {
      'idDriver': _authProvider.getUser().uid,
      'status': 'accepted'
    };
    _timer.cancel();

    _travelInfoProvider.update(data, idProductor);
    _geoFireProvider.delete(_authProvider.getUser().uid);
    Navigator.pushNamedAndRemoveUntil(context, 'reciclador/viaje/map', (route) => false, arguments: idProductor);
    //Navigator.pushReplacementNamed(context, 'reciclador/viaje/map', arguments: idProductor);
  }
  void cancelTravel() {
    Map<String, dynamic> data = {
      'status': 'no_accepted'
    };
    _timer.cancel();
    _travelInfoProvider.update(data, idProductor);
    Navigator.pushNamedAndRemoveUntil(context, 'reciclador/map', (route) => false);
  }

  void getRecicladorInfo() async{
    productor= (await _productorProvider.getById(idProductor));
    print('Productor:${productor.toJson()}');
    refresh();
  }

}