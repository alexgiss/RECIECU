
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';


class TravelHistoryProvider {

  CollectionReference _ref;

  TravelHistoryProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelHistory');
  }

  Future<String> create(TravelHistory travelHistory) async {
    String errorMessage;

    try {
      String id = _ref.doc().id;
      travelHistory.id = id;

      await _ref.doc(travelHistory.id).set(travelHistory.toJson()); // ALMACENAMOS LA INFORMACION
      return id;
    } catch(error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }
  Future<List<TravelHistory>> getByIdProductor(String idProductor) async {
    QuerySnapshot querySnapshot = await _ref.where('idProductor', isEqualTo: idProductor).orderBy('timestamp', descending: false).get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<TravelHistory> travelHistoryList = [];

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      RecicladorProvider recicladorProvider = new RecicladorProvider();
      Reciclador reciclador = await recicladorProvider.getById(travelHistory.idReciclador);
      travelHistory.nameReciclador = reciclador.username;
      travelHistory.phoneReciclador = reciclador.mobile;
    }

    return travelHistoryList;
  }
  Future<List<TravelHistory>> getByIdReciclador(String idReciclador) async {
    QuerySnapshot querySnapshot = await _ref.where('idReciclador', isEqualTo: idReciclador).orderBy('timestamp', descending: false).get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<TravelHistory> travelHistoryList = [];

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      ProductorProvider productorProvider = new ProductorProvider();
      Productor productor = await productorProvider.getById(travelHistory.idProductor);
      travelHistory.nameProductor = productor.username;

    }

    return travelHistoryList;
  }


  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelHistory> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      TravelHistory client = TravelHistory.fromJson(document.data());
      return client;
    }

    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }

}