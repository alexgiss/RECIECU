import 'package:flutter/material.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/providers/travel_history_provider.dart';

class ProductorHistoryDetailController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;
  RecicladorProvider _recicladorProvider;

  TravelHistory travelHistory;
  Reciclador reciclador;

  String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();
    _recicladorProvider = new RecicladorProvider();

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    getTravelHistoryInfo();
  }

  void getTravelHistoryInfo() async {
    travelHistory = await  _travelHistoryProvider.getById(idTravelHistory);
    getDriverInfo(travelHistory.idReciclador);
  }

  void getDriverInfo(String idDriver) async {
    reciclador = await _recicladorProvider.getById(idDriver);
    refresh();
  }

}
