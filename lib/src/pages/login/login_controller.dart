import 'package:flutter/material.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:local/src/utils/shared_pref.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:local/src/utils/snackbar.dart' as utils;

class RegisterController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProductorProvider _productorProvider;
  RecicladorProvider _recicladorProvider;
  ProgressDialog _progressDialog;
  SharedPref _sharedPref;
  String _typeUser;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider= new AuthProvider();
    _productorProvider = new ProductorProvider();
    _recicladorProvider = new RecicladorProvider();
    _progressDialog= MyProgressDialog.createProgressDialog(context, 'Espere un momento .....');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');
    print ('================= TIPO DE USUARIO ====================');
    print (_typeUser);
  }

  void goToRegisterPage(){
    if (_typeUser == 'productor'){
      Navigator.pushNamed(context, 'productor/register');

    }else{
      Navigator.pushNamed(context, 'reciclador/register');
    }


  }


  void login() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    print ('Email: $email');
    print ('Password: $password');
    _progressDialog.show();
    try{
      bool isLogin=  await _authProvider.login(email, password);
      _progressDialog.hide();
      if(isLogin){
        print('El usuario esta logeado');
        if(_typeUser == 'productor'){

          Productor productor = await _productorProvider.getById(_authProvider.getUser().uid);
          print('Productor: $productor');
          if(productor != null){
            print('el cliente no es nulo');
            Navigator.pushNamedAndRemoveUntil(context, 'productor/map', (route) => false);
          }else{
            print('el cliente si es nulo');
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es valido');
            await _authProvider.sigOut();
          }
        }
        else if(_typeUser == 'reciclador'){
          Reciclador reciclador = await _recicladorProvider.getById(_authProvider.getUser().uid);
          if(reciclador != null){
            print('el cliente no es nulo');
            Navigator.pushNamedAndRemoveUntil(context, 'reciclador/map', (route) => false);
          }else{
            print('el cliente si es nulo');
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es valido');
            await _authProvider.sigOut();
          }
        }
        //utils.Snackbar.showSnackbar(context, key, 'El usuario esta logeado');
        //Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);

      }else{
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autentificar');
        print('El usuario no se pudo autentificar');
        //Navigator.pushNamed(context, 'reciclador/map');
      }

    }catch(error){
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }


  }
}