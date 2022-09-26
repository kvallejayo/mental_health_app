import 'dart:convert';

Thought welcomeFromJson(String str) => Thought.fromJson(json.decode(str));

String welcomeToJson(Thought data) => json.encode(data.toJson());

class Thought {

  int id;
  String situation;
  String thoughts;
  String actions;
  String tipForFriend;
  List<dynamic> moodsFelt;
  String createdAt;

  Thought({
    this.id = 0,
    this.situation = "",
    this.thoughts = "",
    this.actions = "",
    this.tipForFriend = "",
    this.moodsFelt = const [],
    this.createdAt = "",
  });

  factory Thought.fromJson(Map<String, dynamic> json) => Thought(
    id: json["id"],
    situation: json["situation"],
    thoughts: json["thoughts"],
    actions: json["actions"],
    tipForFriend: json["tipForFriend"],
    moodsFelt: json["moodsFelt"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "situation": situation,
    "thoughts": thoughts,
    "actions": actions,
    "tipForFriend": tipForFriend,
    "moodsFelt": moodsFelt,
    "createdAt": createdAt,
  };
}