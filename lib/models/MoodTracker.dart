import 'dart:convert';

MoodTracker moodTrackerFromJson(String str) => MoodTracker.fromJson(json.decode(str));
String moodTrackerToJson(MoodTracker data) => json.encode(data.toJson());

class MoodTracker {

  MoodTracker({
    this.id = 0,
    this.moodTrackerDate = "",
    this.mood = "",
    this.message = "",
  });

  int id;
  String moodTrackerDate;
  String mood;
  String message;

  factory MoodTracker.fromJson(Map<String, dynamic> json) => MoodTracker(
      id: json["id"],
      moodTrackerDate: json["moodTrackerDate"],
      mood: json["mood"],
      message: json["message"],
  );

  Map<String, dynamic> toJson() =>{
    "id": id,
    "moodTrackerDate": moodTrackerDate,
    "mood": mood,
    "message": message,
  };
}