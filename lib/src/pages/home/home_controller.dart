import 'package:flutter/material.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/utils/shared_pref.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;
  AuthProvider _authProvider;
  String _typeUser;
  String _isNotification;

  Future init (BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();
    _typeUser = await _sharedPref.read('typeUser');
    _isNotification = await _sharedPref.read('isNotification');
    checkIfUserIsAuth();

  }
  void checkIfUserIsAuth(){
    bool isSigned = _authProvider.isSignedIn();
    if(isSigned){
      if(_typeUser == 'productor'){
       Navigator.pushNamedAndRemoveUntil(context, 'productor/map', (route) => false);
        //Navigator.pushNamed(context, 'productor/map');
      }else{
       Navigator.pushNamedAndRemoveUntil(context, 'reciclador/map', (route) => false);
        //Navigator.pushNamed(context, 'reciclador/map');
      }


    }else{
      print('NO ESTA LOGEADO');
    }
  }

  void goToLoginPage(String typeUser){
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) async{
    _sharedPref.save('typeUser', typeUser);

  }

}