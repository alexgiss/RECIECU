import 'package:flutter/material.dart';

class BottomSheetRecicladorInfo extends StatefulWidget {

  String imageUrl;
  String username;
  String email;
  String mobile;

  BottomSheetRecicladorInfo({
    this.imageUrl,
    this.username,
    this.email,
    this.mobile,

  });

  @override
  _BottomSheetRecicladorInfoState createState() => _BottomSheetRecicladorInfoState();

}

class _BottomSheetRecicladorInfoState extends State<BottomSheetRecicladorInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            'Tu Cliente',
            style: TextStyle(
              fontSize: 16
            ),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            backgroundImage:widget.imageUrl != null
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
              widget.email ,
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
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
            leading: Icon(Icons.phone_android),
          )

        ],
      ),
    );
  }
}
