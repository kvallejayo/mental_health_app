import 'dart:convert';

class Medal {

  String message;
  String image;
  bool Function() earnCondition;
  int pointsWorth;

  Medal({
    required this.message,
    required this.image,
    required this.earnCondition,
    required this.pointsWorth,
  });

}
