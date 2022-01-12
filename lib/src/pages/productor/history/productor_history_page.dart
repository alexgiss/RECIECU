import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:local/src/models/travel_history.dart';
import 'package:local/src/pages/productor/history/productor_history_controller.dart';
import 'package:local/src/utils/relative_time_util.dart';
import 'package:local/src/utils/colors.dart' as utils;
class ProductorHistoryPage extends StatefulWidget {
  @override
  _ProductorHistoryPageState createState() => _ProductorHistoryPageState();
}

class _ProductorHistoryPageState extends State<ProductorHistoryPage> {

  ProductorHistoryController _con = new ProductorHistoryController();

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
        key: _con.key,
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
          title: Text('Historial de reciclaje'),),
        body: FutureBuilder(
          future: _con.getAll(),
          builder: (context, AsyncSnapshot<List<TravelHistory>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (_, index) {
                  return _cardHistoryInfo(
                    snapshot.data[index].from,
                    snapshot.data[index].to,
                    snapshot.data[index].nameReciclador,
                    snapshot.data[index].phoneReciclador,
                    snapshot.data[index].detalle,
                    snapshot.data[index].calificationReciclador?.toString(),
                    RelativeTimeUtil.getRelativeTime(snapshot.data[index].timestamp ?? 0),
                    snapshot.data[index].id,
                  );
                }
            );
          },
        )
    );
  }

  Widget _cardHistoryInfo(
      String from,
      String to,
      String name,
      String mobile,
      String detalle,
      String calification,
      String timestamp,
      String idTravelHistory,
      ) {
    return GestureDetector(
      onTap: () {
        _con.goToDetailHistory(idTravelHistory);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          children: [

            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.accessibility_new_rounded),
                SizedBox(width: 5),
                Text(
                  'Reciclador: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.add_ic_call_outlined),
                SizedBox(width: 5),
                Text(
                  'Telefono: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    mobile ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(
                  'Principal: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    from ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(
                  'Transversal: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    to ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),

            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.star_border),
                SizedBox(width: 5),
                Text(
                  'Calificacion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    calification ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.format_list_numbered),
                SizedBox(width: 5),
                Text(
                  'Detalle: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    detalle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(
                  'Hace: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    timestamp ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
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
