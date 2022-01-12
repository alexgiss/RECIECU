import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthProvider{
  final _firebaseAuth = FirebaseAuth.instance;
  User getUser(){
    return _firebaseAuth.currentUser;
  }
  bool isSignedIn(){
    final currentUser= _firebaseAuth.currentUser;
    if(currentUser == (null)){
      return false;
    }
    return true;
  }
  void checkIfUserIsLogged(BuildContext context, String typeUser){
    FirebaseAuth.instance.authStateChanges().listen((User user)  async {

      if(user != (null)  && typeUser != (null)){

        if(typeUser == 'productor'){
          Navigator.pushNamedAndRemoveUntil(context, 'productor/map', (route) => false);




        }else{
          Navigator.pushNamedAndRemoveUntil(context, 'reciclador/map', (route) => false);
          

        }

        print('el usuario esta logeado');
       
      }else{
        print('el usuario no esta logeado');
      }
    });
  }


  Future<bool> login (String email, String password) async {
      var errorMessage;
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        await _firebaseAuth.currentUser.sendEmailVerification();

      } catch (error) {
        print(error);
        errorMessage = error.toString();
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
      //return true;
      return true;

  }
  Future<bool> register(String email, String password) async {
    var errorMessage;
    try{
       await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
       await _firebaseAuth.currentUser.sendEmailVerification();

    }catch(error){
      print(error);
     errorMessage= error.toString();
    }
    if(errorMessage !=  null){
      return Future.error(errorMessage);
    }
    return true;
  }
  Future<void> sigOut() {
    return Future.wait([_firebaseAuth.signOut()]);
  }
}