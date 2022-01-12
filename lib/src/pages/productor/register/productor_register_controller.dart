import 'package:flutter/material.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class ProductorRegisterController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  AuthProvider _authProvider;
  ProductorProvider _productorProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider= new AuthProvider();
    _productorProvider= new ProductorProvider();
    _progressDialog= MyProgressDialog.createProgressDialog(context, 'Espere un momento .....');
  }


  void register() async{
    String username = usernameController.text;
    String email = emailController.text.trim();
    String mobile = mobileController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();

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
        Productor productor = new Productor(
          id: _authProvider.getUser().uid,
          username: username,
          email: _authProvider.getUser().email,
          mobile: mobile,
          password: password,


        );
        await _productorProvider.create(productor);

        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'productor/map', (route) => false);
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