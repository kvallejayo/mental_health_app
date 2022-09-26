import 'dart:convert';

Affirmation welcomeFromJson(String str) => Affirmation.fromJson(json.decode(str));
String welcomeToJson(Affirmation data) => json.encode(data.toJson());

class Affirmation {

  int id;
  String message;
  String creationDate;

  Affirmation({
    this.id = 0,
    this.message = '',
    this.creationDate = '',
  });

  factory Affirmation.fromJson(Map<String, dynamic> json) => Affirmation(
    id: json["id"],
    message: json["message"],
    creationDate: json["creationDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "creationDate": creationDate,
  };
}
