import 'package:flutter/material.dart';

class Alarm {
  bool isEnabled = true;
  int hour;
  int minute;
  /*
  DateTime monday": null,
  DateTime tuesday": null,
  DateTime wednesday": null,
  DateTime thursday": null,
  DateTime friday": null,
  DateTime saturday": null,
  DateTime sunday": null,
  DateTime fireTime": DateTime.now(),
  DateTime enable": true,

   */

  Alarm({
    Key? key,
    required this.hour,
    required this.minute,
  }){
    print("sdfsd");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
