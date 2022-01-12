import 'dart:convert';

TravelHistory travelHistoryFromJson(String str) => TravelHistory.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistory data) => json.encode(data.toJson());

class TravelHistory {
  TravelHistory({
    this.id,
    this.idProductor,
    this.idReciclador,
    this.from,
    this.to,
    this.detalle,
    this.timestamp,
    this.calificationProductor,
    this.calificationReciclador,
    this.nameReciclador,
    this.nameProductor,
    this.phoneReciclador,
  });

  String id;
  String idProductor;
  String idReciclador;
  String from;
  String to;
  String detalle;
  int timestamp;
  double calificationProductor;
  double calificationReciclador;
  String nameReciclador;
  String nameProductor;
  String phoneReciclador;

  factory TravelHistory.fromJson(Map<String, dynamic> json) => TravelHistory(
    id: json["id"],
    idProductor: json["idProductor"],
    idReciclador: json["idReciclador"],
    from: json["from"],
    to: json["to"],
    detalle: json["detalle"],
    nameReciclador: json["nameReciclador"],
    nameProductor: json["nameProductor"],
    phoneReciclador: json["phoneReciclador"],
    timestamp: json["timestamp"],
    calificationProductor: json["calificationProductor"]?.toDouble() ?? 0,
    calificationReciclador: json["calificationReciclador"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idProductor": idProductor,
    "idReciclador": idReciclador,
    "from": from,
    "to": to,
    "detalle": detalle,
    "nameReciclador": nameReciclador,
    "nameProductor": nameProductor,
    "phoneReciclador": phoneReciclador,
    "timestamp": timestamp,
    "calificationProductor": calificationProductor,
    "calificationReciclador": calificationReciclador,
  };
}
