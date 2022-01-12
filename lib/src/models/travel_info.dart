
import 'dart:convert';

TravelInfo travelInfoFromJson(String str) => TravelInfo.fromJson(json.decode(str));

String travelInfoToJson(TravelInfo data) => json.encode(data.toJson());

class TravelInfo {
  String id;
  String detalle;
  String status;
  String idDriver;
  String from;
  String to;
  String idTravelHistory;
  double fromLat;
  double fromLng;
  double toLat;
  double toLng;

  TravelInfo({
    this.id,
    this.detalle,
    this.status,
    this.idDriver,
    this.from,
    this.to,
    this.idTravelHistory,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,

  });



  factory TravelInfo.fromJson(Map<String, dynamic> json) => TravelInfo(
    id: json["id"],
    detalle: json["detalle"],
    status: json["status"],
    idDriver: json["idDriver"],
    from: json["from"],
    to: json["to"],
    idTravelHistory: json["idTravelHistory"],
    fromLat: json["fromLat"]?.toDouble() ?? 0,
    fromLng: json["fromLng"]?.toDouble() ?? 0,
    toLat: json["toLat"]?.toDouble() ?? 0,
    toLng: json["toLng"]?.toDouble() ?? 0,

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "detalle": detalle,
    "status": status,
    "idDriver": idDriver,
    "from": from,
    "to": to,
    "idTravelHistory": idTravelHistory,
    "fromLat": fromLat,
    "fromLng": fromLng,
    "toLat": toLat,
    "toLng": toLng,

  };
}