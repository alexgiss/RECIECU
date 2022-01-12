import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/pages/productor/viaje_map/productor_viaje_map_controller.dart';



class ProductorViajeMapPage extends StatefulWidget {
  @override
  _ProductorViajeMapPageState createState() => _ProductorViajeMapPageState();
}

class _ProductorViajeMapPageState extends State<ProductorViajeMapPage> {

  ProductorViajeMapController _con = new ProductorViajeMapController();

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
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonUserInfo(),
                    _cardStatusInfo(_con.currentStatus),

                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardStatusInfo(String status) {
    return SafeArea(
        child: Container(
          width: 110,
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: _con.colorStatus,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '$status',
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }
  Widget _buttonUserInfo() {
    return GestureDetector(
      onTap: _con.openBottomSheet,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}
