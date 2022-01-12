import 'package:flutter/material.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/travel_history_provider.dart';


class ProductorHistoryController {

  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();

    refresh();
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider.getByIdProductor(_authProvider.getUser().uid);
  }
  void goToDetailHistory(String id) {
    Navigator.pushNamed(context, 'productor/history/detail', arguments: id);
  }

}