import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:local/src/pages/reciclador/history_detail/reciclador_history_detail_controller.dart';
import 'package:local/src/utils/colors.dart' as utils;
class RecicladorHistoryDetailPage extends StatefulWidget {
  @override
  _RecicladorHistoryDetailPageState createState() => _RecicladorHistoryDetailPageState();
}

class _RecicladorHistoryDetailPageState extends State<RecicladorHistoryDetailPage> {

  RecicladorHistoryDetailController _con = new RecicladorHistoryDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
              )
          ),
        ),
        title: Text('Detalle del historial'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerInfoReciclador(),
            _listTileInfo('Principal', _con.travelHistory?.from, Icons.location_on),
            _listTileInfo('Transversal', _con.travelHistory?.to, Icons.location_on),
            _listTileInfo('Mi calificacion', _con.travelHistory?.calificationReciclador?.toString(), Icons.star_border),
            _listTileInfo('Calificacion del productor', _con.travelHistory?.calificationProductor?.toString(), Icons.star),
            _listTileInfo('Oferta', _con.travelHistory?.detalle?.toString(), Icons.add_shopping_cart_rounded),

          ],
        ),
      ),
    );
  }

  Widget _listTileInfo(String title, String value, IconData icon) {
    return ListTile(
      title: Text(
          title ?? ''
      ),
      subtitle: Text(value ?? ''),
      leading: Icon(icon),
    );
  }

  Widget _bannerInfoReciclador() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [utils.Colors.uberCloneColor4,utils.Colors.uberCloneColor2]
            )
        ),
        height: MediaQuery.of(context).size.height * 0.27,
        width: double.infinity,
        //color: utils.Colors.uberCloneColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            CircleAvatar(
              backgroundImage: _con.productor?.image != null
                  ? NetworkImage(_con.productor?.image)
                  : AssetImage('assets/img/profile.jpg'),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              _con.productor?.username ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {

    });
  }
}
