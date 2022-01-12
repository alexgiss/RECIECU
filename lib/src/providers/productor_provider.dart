import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local/src/models/productor.dart';

class ProductorProvider{
  CollectionReference _ref;

  ProductorProvider(){
    _ref= FirebaseFirestore.instance.collection('Productor');
  }

  Future <void> create (Productor productor) async{
    var errorMessage;

    try{
      return _ref.doc(productor.id).set(productor.toJson());

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
  Future<Productor> getById(String id )async{
    DocumentSnapshot document = await _ref.doc(id).get();

    if(document.exists){
      Productor productor = Productor.fromJson(document.data());
      return productor;

    }
    return null;

  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  }