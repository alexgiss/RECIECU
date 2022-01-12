import 'package:flutter/material.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class RecicladorRegisterController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();
  TextEditingController pin7Controller = new TextEditingController();
  TextEditingController pin8Controller = new TextEditingController();
  TextEditingController pin9Controller = new TextEditingController();
  TextEditingController pin10Controller = new TextEditingController();
  AuthProvider _authProvider;
  RecicladorProvider _recicladorProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider= new AuthProvider();
    _recicladorProvider= new RecicladorProvider();
    _progressDialog= MyProgressDialog.createProgressDialog(context, 'Espere un momento .....');
  }


  void register() async{
    String username = usernameController.text;
    String email = emailController.text.trim();
    String mobile = mobileController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();
    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();
    String pin7 = pin7Controller.text.trim();
    String pin8 = pin8Controller.text.trim();
    String pin9 = pin9Controller.text.trim();
    String pin10 = pin10Controller.text.trim();
    String plate ='$pin1$pin2$pin3$pin4$pin5$pin6$pin7$pin8$pin9$pin10';
    print ('Email: $email');
    print ('Password: $password');

    if(username.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty && mobile.isEmpty){
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(context, key, 'debes ingresar todos los campos');

      return;
    }

    if(confirmPassword != password){
      print('las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(context, key, 'las contraseñas no coinciden');
      return;
    }

    if(password.length<6){
      print('el password debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'el password debe tener al menos 6 caracteres');
      return;
    }
    _progressDialog.show();
    try{
      bool isRegister=  await _authProvider.register(email, password);
      if(isRegister){
        Reciclador reciclador = new Reciclador(
          id: _authProvider.getUser().uid,
          username: username,
          email: _authProvider.getUser().email,
          mobile: mobile,
          password: password,
          plate:plate,



        );
        await _recicladorProvider.create(reciclador);

        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'reciclador/map', (route) => false);
        utils.Snackbar.showSnackbar(context, key, 'El usuario se registro corectamente');
        print('El usuario se registro corectamente');
      }else{
        _progressDialog.hide();
        print('El usuario no se pudo registrar');
      }

    }catch(error){
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }


  }
}