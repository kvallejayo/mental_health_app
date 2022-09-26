import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
  Reminder({
    this.id = 0,
    this.reminderDate = '',
    this.message = '',
  });
  int id;
  String reminderDate;
  String message;

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json["id"],
        reminderDate: json["reminderDate"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reminderDate": reminderDate,
        "message": message,
      };
}
