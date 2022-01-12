import 'package:flutter/material.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/travel_history_provider.dart';

class RecicladorHistoryDetailController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;
  ProductorProvider _productorProvider;

  TravelHistory travelHistory;
  Productor productor;

  String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();
    _productorProvider = new ProductorProvider();

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    getTravelHistoryInfo();
  }

  void getTravelHistoryInfo() async {
    travelHistory = await  _travelHistoryProvider.getById(idTravelHistory);
    getProductorInfo(travelHistory.idProductor);
  }

  void getProductorInfo(String idProductor) async {
    productor = await _productorProvider.getById(idProductor);
    refresh();
  }

}
