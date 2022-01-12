import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/src/models/productor.dart';
import 'package:local/src/providers/auth_provider.dart';
import 'package:local/src/providers/productor_provider.dart';
import 'package:local/src/providers/storage_provider.dart';
import 'package:local/src/utils/my_progress_dialog.dart';
import 'package:local/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';
class ProductorEditController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  AuthProvider _authProvider;
  ProductorProvider _productorProvider;
  ProgressDialog _progressDialog;
  StorageProvider _storageProvider;
  PickedFile pickedFile;
  File imageFile;
  Productor productor;

  Future init (BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _productorProvider = new ProductorProvider();
    _storageProvider = new StorageProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    getUserInfo();
  }
  void getUserInfo() async {
    productor = await _productorProvider.getById(_authProvider.getUser().uid);
    usernameController.text = productor.username;
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
  void update() async {
    String username = usernameController.text;

    if (username.isEmpty) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(context, key, 'Debes ingresar todos los campos');
      return;
    }
    _progressDialog.show();

    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'image': productor?.image ?? null,
        'username': username,
      };

      await _productorProvider.update(data, _authProvider.getUser().uid);
      _progressDialog.hide();
    }
    else {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile);
      String imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': username,
      };

    await _productorProvider.update(data, _authProvider.getUser().uid);
    }
    _progressDialog.hide();
    utils.Snackbar.showSnackbar(context, key, 'Los datos se actualizaron');

  }


  Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    else {
      print('No selecciono ninguna imagen');
    }
    Navigator.pop(context);

    refresh();
  }

}