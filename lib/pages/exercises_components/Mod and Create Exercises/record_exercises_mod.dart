// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/Exercise.dart';
import 'package:mental_health_app/pages/exercises_components/exercises_record.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

import '../../../Components/my_calendar.dart';
import '../../../components/my_input_field.dart';
import '../../../themes/my_colors.dart';

class RecordExercisesMod extends StatefulWidget {
  final String idSend;
  Exercise exercise;
  RecordExercisesMod({required this.idSend, required this.exercise});
  @override
  State<RecordExercisesMod> createState() => _RecordExercisesModState();
}

class _RecordExercisesModState extends State<RecordExercisesMod> {
  late DateTime startDate;
  late DateTime endDate;
  final TextEditingController message = TextEditingController();
  DateTime selectedDay = DateTime.now();
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  @override
  void initState() {

    selectedDay = DateTime.parse(widget.exercise.startDate);
    startDate = DateTime.parse(widget.exercise.startDate);
    endDate = DateTime.parse(widget.exercise.endDate);
    message.text = widget.exercise.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/ejercicios fisicos.png'),
            SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  TitleHeader("Modificar Ejercicio"),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyCalendar(
                          rangeSelectionMode: false,
                          focusedDay: selectedDay,
                          onDaySelected: (_selectedDay){
                            selectedDay = DateTime(
                              _selectedDay!.year,
                              _selectedDay.month,
                              _selectedDay.day,
                              selectedDay.hour,
                              selectedDay.minute,
                            );
                          },
                        ),
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: intensePurple,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Modificar registro de ejercicio",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              MyInputField(
                                controller: message,
                                labelText: "Escribir recordatorio",
                                backgroundColor: Colors.white,
                                hintInsteadOfLabel: true,
                              ),

                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 45,
                                        child: Text(
                                          "Hora inicial",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(":",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      SizedBox(width: 5,),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.watch_later_outlined),
                                                SizedBox(width: 5,),
                                                Text(DateFormat.jm().format(startDate)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          //_showIni(context);
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(hour: startDate.hour, minute: startDate.minute),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Color(0xFF9296BB),
                                                  ),
                                                  textButtonTheme: TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      primary: Color(0xFF9296BB),
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },

                                          );
                                          if (pickedTime  == null) return;

                                          final newPickedDate = DateTime(
                                            selectedDay.year,
                                            selectedDay.month,
                                            selectedDay.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          startDate = newPickedDate;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        child: Text(
                                          "Hora Final",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(":",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      SizedBox(width: 5,),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.watch_later_outlined),
                                                SizedBox(width: 5,),
                                                Text(DateFormat.jm().format(endDate)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //ontap setstate to get time
                                        onTap: () async {
                                          //_showIni(context);
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(hour: endDate.hour, minute: endDate.minute),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: Color(0xFF9296BB),
                                                  ),
                                                  textButtonTheme: TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      primary: Color(0xFF9296BB),
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (pickedTime  == null) return;
                                          final newPickedDate = DateTime(
                                            selectedDay.year,
                                            selectedDay.month,
                                            selectedDay.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          endDate = newPickedDate;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(13),
                                      child: Text(
                                        "MODIFICAR EJERCICIO",
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          color: waterGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onPressed: ()async{

                                      var userName = await UserSecureStorage.getUsername();
                                      var password = await UserSecureStorage.getPassword();
                                      widget.exercise.startDate = DateFormat('yyyy-MM-dd HH:mm').format(startDate);
                                      widget.exercise.endDate = DateFormat('yyyy-MM-dd HH:mm').format(endDate);
                                      widget.exercise.message = message.text;

                                      await dataBaseHelper.updateExercise(
                                        widget.idSend,
                                        userName.toString(),
                                        password.toString(),
                                        widget.exercise,
                                      ).then((value) => Alert(
                                        context: context, type: AlertType.success,
                                        title: "MODIFICACI??N EXITOSA",
                                        desc: "??Se modific?? con ??xito su sesi??n de ejercicio!",
                                        buttons: [
                                          DialogButton(
                                            color: waterGreen,
                                            child: Text(
                                              "Aceptar",
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ).show());
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
