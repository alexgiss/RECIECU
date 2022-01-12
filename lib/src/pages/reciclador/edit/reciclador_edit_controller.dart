import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/src/models/reciclador.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/reciclador_provider.dart';
import 'package:local/src/providers/storage_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
class RecicladorEditController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;

  TextEditingController usernameController = new TextEditingController();
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
  StorageProvider _storageProvider;
  ProgressDialog _progressDialog;
  PickedFile pickedFile;
  File imageFile;
  Reciclador reciclador;


  Future init (BuildContext context,Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _recicladorProvider = new RecicladorProvider();
    _storageProvider = new StorageProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    getUserInfo();
  }
  void getUserInfo() async {
    reciclador = await _recicladorProvider.getById(_authProvider.getUser().uid);
    usernameController.text = reciclador.username;

    pin1Controller.text = reciclador.plate[0];
    pin2Controller.text = reciclador.plate[1];
    pin3Controller.text = reciclador.plate[2];
    pin4Controller.text = reciclador.plate[3];
    pin5Controller.text = reciclador.plate[4];
    pin6Controller.text = reciclador.plate[5];
    pin7Controller.text = reciclador.plate[6];
    pin8Controller.text = reciclador.plate[7];
    pin9Controller.text = reciclador.plate[8];
    pin10Controller.text = reciclador.plate[9];

    refresh();
  }
  void showAlertDialog() {

    Widget galleryButton = FlatButton(
        onPressed: () {
          getImageFromGallery(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = FlatButton(
        onPressed: () {
          getImageFromGallery(ImageSource.camera);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );

  }

  Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    else {
      print('No selecciono ninguna imagen');
    }
    Navigator.pop(context);
    refresh();
  }


  void update() async {
    String username = usernameController.text;
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

    String plate = '$pin1$pin2$pin3$pin4$pin5$pin6$pin7$pin8$pin9$pin10';
    if (username.isEmpty) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(context, key, 'Debes ingresar todos los campos');
      return;
    }
    _progressDialog.show();

    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'image': reciclador?.image ?? null,
        'username': username,
        'plate': plate,
      };

      await _recicladorProvider.update(data, _authProvider.getUser().uid);
      _progressDialog.hide();
    }
    else {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile);
      String imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': username,
        'plate': plate,
      };

      await _recicladorProvider.update(data, _authProvider.getUser().uid);
    }

    _progressDialog.hide();

    utils.Snackbar.showSnackbar(context, key, 'Los datos se actualizaron');

  }

}
