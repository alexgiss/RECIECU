import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ProductorIngresopController{
  BuildContext context;
  Function refresh;
  String from;
  String to;
  String detalle;
  LatLng fromLatLng;
  LatLng toLatLng;


  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController detalleController = new TextEditingController();

  Future init (BuildContext context, Function refresh) async {
    this.context=context;
    this.refresh=refresh;
    Map<String, dynamic> arguments= ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    detalle = arguments['detalle'];
    fromLatLng= arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    refresh();

  }

  void goRequest(){
    String detalle = detalleController.text;
    Navigator.pushNamed(context, 'productor/viaje/info', arguments: {
      'from': from,
      'to': to,
      'detalle': detalle,
      'fromLatLng': fromLatLng,
      'toLatLng': toLatLng,
    });
  }

}