import 'dart:convert';

Exercise exerciseFromJson(String str) => Exercise.fromJson(json.decode(str));

String exerciseToJson(Exercise data) => json.encode(data.toJson());

class Exercise {
  Exercise({
    this.id = 0,
    this.duration = '',
    this.startDate = '',
    this.endDate="",
    this.dayOfTheWeek = '',
    this.message="",
  });
  //constructor

  int id;
  String duration;
  String startDate;
  String endDate;
  String dayOfTheWeek;
  String message;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        duration: json["duration"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        dayOfTheWeek: json["dayOfTheWeek"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "duration": duration,
        "startDate": startDate,
        "endDate": endDate,
        "dayOfTheWeek": dayOfTheWeek,
        "message": message,
      };
}
