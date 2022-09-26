// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Exercise.dart';
import '../models/SleepRecord.dart';
import '../pages/exercises_components/exercises_record.dart';
import '../pages/sleep_records_component/sleep_records.dart';
import '../security/user_secure_storage.dart';

import '../themes/my_colors.dart';
import '../utils/endpoints.dart';
import 'my_labels.dart';

class ScreenFormDiary extends StatelessWidget {
  ScreenFormDiary(this.h1, this.input, this.button);
  String h1;
  String input;
  String button;
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(128, 124, 183, 10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  h1,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            InputLabel(input, TextEditingController()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: waterGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(button,
                    style: TextStyle(
                        fontSize: 15.5,
                        color: Color.fromRGBO(107, 174, 174, 10),
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenFormExercises extends StatefulWidget {
  final String idSend;
  final String selectedDayString;

  ScreenFormExercises(
      this.h1, this.input, this.button, this.idSend, this.selectedDayString);
  String h1;
  String input;
  String button;

  @override
  State<ScreenFormExercises> createState() => _ScreenFormExercisesState();
}

class _ScreenFormExercisesState extends State<ScreenFormExercises> {
  int contadorHoras = 0;
  int contadorMinutos = 0;
  int contadorHoras2 = 0;
  int contadorMinutos2 = 0;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final TextEditingController _dateController = TextEditingController();
  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    final token = await UserSecureStorage.getToken() ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int contadorHoras = 0;
    int contadorMinutos = 0;
    init();
    print("El id es: ${widget.idSend}");
    print("El dia es: ${widget.selectedDayString}");
  }

  void aumentar_horas() {
    setState(() {
      if (contadorHoras < 23) contadorHoras++;
    });
  }

  void disminuir_horas() {
    setState(() {
      if (contadorHoras > 0) contadorHoras--;
    });
  }

  void aumentar_minutos() {
    setState(() {
      if (contadorMinutos < 59) contadorMinutos++;
    });
  }

  void disminuir_minutos() {
    setState(() {
      if (contadorMinutos > 0) contadorMinutos--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 350,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(128, 124, 183, 10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.h1,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 70,
              //color: Colors.white,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 242, 250, 10),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ]),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      dragStartBehavior: DragStartBehavior.start,
                      decoration: InputDecoration.collapsed(
                          hintText: "Escribir una Fecha"),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text("$contadorHoras horas"),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            color: Colors.white,
                            onPressed: aumentar_horas,
                            icon: Icon(Icons.arrow_drop_up)),
                        IconButton(
                            color: Colors.white,
                            onPressed: disminuir_horas,
                            icon: Icon(Icons.arrow_drop_down))
                      ],
                    )
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text("$contadorMinutos minutos"),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            color: Colors.white,
                            onPressed: aumentar_minutos,
                            icon: Icon(Icons.arrow_drop_up)),
                        IconButton(
                            color: Colors.white,
                            onPressed: disminuir_minutos,
                            icon: Icon(Icons.arrow_drop_down))
                      ],
                    )
                  ],
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: waterGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.selectedDayString == "exercises") {
                      Exercise exercise = Exercise();
                      var userName = await UserSecureStorage.getUsername();
                      var password = await UserSecureStorage.getPassword();
                      var horas;
                      var minutos;
                      if (contadorHoras < 10) {
                        horas = "0$contadorHoras";
                      } else {
                        horas = "$contadorHoras";
                      }
                      if (contadorMinutos < 10) {
                        minutos = "0$contadorMinutos";
                      } else {
                        minutos = "$contadorMinutos";
                      }
                      exercise.duration =
                          "$horas horas y $minutos minutos";
                      //exercise.exerciseDate = _dateController.text;
                      exercise = await dataBaseHelper.createExercise(
                        widget.idSend,
                        userName.toString(),
                        password.toString(),
                        exercise,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ExercisesRecordPage(widget.idSend)),
                      ).then((value) => setState(() {}));
                    } else if (widget.selectedDayString == "dream") {
                      SleepRecord sleepRecord = SleepRecord();
                      var userName = await UserSecureStorage.getUsername();
                      var password = await UserSecureStorage.getPassword();
                      // obtener la fecha actual
                      var now = new DateTime.now();
                      var formatter = new DateFormat('yyyy-MM-dd HH:mm');
                      print("fecha inicial: ${formatter}");
                      sleepRecord.startDate = formatter.format(now);

                      var horas;
                      var minutos;
                      if (contadorHoras < 10) {
                        horas = "0$contadorHoras";
                      } else {
                        horas = "$contadorHoras";
                      }
                      if (contadorMinutos < 10) {
                        minutos = "0$contadorMinutos";
                      } else {
                        minutos = "$contadorMinutos";
                      }
                      print(sleepRecord.endDate);
                      sleepRecord.endDate =
                          "${_dateController.text} $horas:$minutos";
                      print(sleepRecord.endDate);
                      sleepRecord = await dataBaseHelper.createASleepRecord(
                        widget.idSend,
                        userName.toString(),
                        password.toString(),
                        sleepRecord,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SleepRecordsPage(widget.idSend),
                        ),
                      ).then((value) => setState(() {}));
                    }
                  },
                  child: Text(widget.button,
                    style: TextStyle(
                        fontSize: 15.5,
                        color: Color.fromRGBO(107, 174, 174, 10),
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
