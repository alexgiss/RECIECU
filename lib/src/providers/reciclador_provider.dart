import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local/src/models/reciclador.dart';

class RecicladorProvider{
  CollectionReference _ref;

  RecicladorProvider(){
    _ref= FirebaseFirestore.instance.collection('Reciclador');
  }

  Future <void> create (Reciclador reciclador) async{
    var errorMessage;

    try{
      return _ref.doc(reciclador.id).set(reciclador.toJson());

    }catch(error){
      errorMessage = error.toString();
    }
    if(errorMessage != null){
      return Future.error(errorMessage);

    }
  }
  Stream<DocumentSnapshot> getByIdStream(String id){
    return _ref.doc(id).snapshots(includeMetadataChanges: true);

  }
  Future<Reciclador> getById(String id) async{
    DocumentSnapshot document = await _ref.doc(id).get();


    if(document.exists){
      Reciclador reciclador = Reciclador.fromJson(document.data());
      return reciclador;
    }
   return null;

  }
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  }