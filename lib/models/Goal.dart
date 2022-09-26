// To parse this JSON data, do
//
//     final goal = goalFromJson(jsonString);

import 'dart:convert';

Goal goalFromJson(String str) => Goal.fromJson(json.decode(str));

String goalToJson(Goal data) => json.encode(data.toJson());

class Goal {
  Goal({
    this.id = 0,
    this.type = '',
    this.message = '',
    this.actionPlan1 = '',
    this.actionPlan2 = '',
    this.actionPlan3 = '',
    this.startDate = '',
    this.status = '',
  });

  int id;
  String type;
  String message;
  String actionPlan1;
  String actionPlan2;
  String actionPlan3;
  String startDate;
  String status;

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"],
    type: json["type"],
    message: json["message"],
    actionPlan1: json["actionPlan1"],
    actionPlan2: json["actionPlan2"],
    actionPlan3: json["actionPlan3"],
    startDate: json["startDate"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "message": message,
    "actionPlan1": actionPlan1,
    "actionPlan2": actionPlan2,
    "actionPlan3": actionPlan3,
    "startDate": startDate,
    "status": status,
  };
}
