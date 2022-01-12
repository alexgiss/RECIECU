import 'package:flutter/material.dart';

class BottomSheetProductorInfo extends StatefulWidget {
  String imageUrl;
  String username;
  String email;
  String plate;
  String mobile;

  BottomSheetProductorInfo({
     this.imageUrl,
     this.username,
     this.email,
     this.plate,
     this.mobile,
  });

  @override
  _BottomSheetProductorInfoState createState() => _BottomSheetProductorInfoState();
}

class _BottomSheetProductorInfoState extends State<BottomSheetProductorInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            'Tu Reciclador',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl)
                : AssetImage('assets/img/profile.jpg'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username,
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'Correo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email,
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text(
              'Cedula Reciclador',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.plate,
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.account_balance_wallet_sharp),
          ),
          ListTile(
            title: Text(
              'Teléfono Reciclador',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.mobile,
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.account_balance_wallet_sharp),
          )
        ],
      ),
    );
  }
}
