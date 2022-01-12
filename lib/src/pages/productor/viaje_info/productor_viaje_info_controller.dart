import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/src/api/environment.dart';
class ProductorViajeInfoController{
  BuildContext context;
  Function refresh;

GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
Completer<GoogleMapController> _mapController= Completer();
CameraPosition initialPosition = CameraPosition(
    target: LatLng(-0.2508395, -78.5210313),
    zoom: 14.0
);
Map<MarkerId, Marker> markers= <MarkerId, Marker>{};
  String from;
  String to;
  String detalle;
  LatLng fromLatLng;
  LatLng toLatLng;
  Set<Polyline> polylines= {};
  List<LatLng> points = [];
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;
  Future init(BuildContext context,Function refresh) async {
    this.context=context;
    this.refresh=refresh;
    Map<String, dynamic> arguments= ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    detalle = arguments['detalle'];
    fromLatLng= arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');
    animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
    refresh();
  }
  Future <void> setPolylines()async{
    PointLatLng pointFromLatLng=PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng=PointLatLng(toLatLng.latitude, toLatLng.longitude);
    PolylineResult result= await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng
    );

  for(PointLatLng point in result.points){
    points.add(LatLng(point.latitude, point.longitude));
  }
  Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.amber,
      points: points,
    width: 6
  );
  polylines.add(polyline);

  addMarker('from', fromLatLng.latitude, fromLatLng.longitude, 'Recoger Aqui', '', fromMarker);
  addMarker('from', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);
    refresh();
}
Future animateCameraToPosition(double latitude, double longitude) async {
  GoogleMapController controller = await _mapController.future;
  if(controller != null){
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 0,
            target: LatLng(latitude, longitude),
            zoom: 15
        )
    ));
  }
}
  void onMapCreated(GoogleMapController controller) async{
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
    await setPolylines();

  }
Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async{
  ImageConfiguration configuration = ImageConfiguration();
  BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
  return bitmapDescriptor;

}
void goToRequest(){
    Navigator.pushNamed(context, 'productor/viaje/request', arguments: {
      'from': from,
      'to': to,
      'detalle': detalle,
      'fromLatLng': fromLatLng,
      'toLatLng': toLatLng,
    });
}
void addMarker(
    String markerId,
    double lat,
    double lng,
    String title,
    String content,
    BitmapDescriptor iconMarker
    ){
  MarkerId id = MarkerId(markerId);
  Marker marker=Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),

  );
  markers[id]= marker;
}


}