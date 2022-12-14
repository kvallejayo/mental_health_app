// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/components/my_calendar.dart';
import 'package:mental_health_app/themes/my_colors.dart';

import '../../Components/background_image.dart';
import '../../Components/my_labels.dart';
import '../../components/my_input_field.dart';
import '../../models/Reminder.dart';
import '../../security/user_secure_storage.dart';
import '../../utils/endpoints.dart';

class ModifyReminder extends StatefulWidget {
  final String userId;
  Reminder reminder;
  ModifyReminder({required this.userId, required this.reminder});

  @override
  State<ModifyReminder> createState() => _ModifyReminderState();
}

class _ModifyReminderState extends State<ModifyReminder> {
  final TextEditingController controllerMessage = TextEditingController();
  late DateTime selectedDay;
  DateTime focusedDay = DateTime.now();
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  @override
  void initState() {
    controllerMessage.text = widget.reminder.message;
    selectedDay = DateTime.parse(widget.reminder.reminderDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Stack(
            children: [
              BackgroundImage('assets/fondos/recordatorio.png'),
              Column(
                children: [
                  TitleHeader("Crear recordatorio"),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyCalendar(
                          focusedDay: selectedDay,
                          rangeSelectionMode: false,
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
                                  "Recordatorio",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              MyInputField(
                                controller: controllerMessage,
                                labelText: "Escribir recordatorio",
                                backgroundColor: Colors.white,
                                hintInsteadOfLabel: true,
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Hora",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: 150,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: waterGreen,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            DateFormat.jm("es_US").format(selectedDay),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(Icons.watch_later_outlined, color: Colors.white,),
                                        ],
                                      ),
                                    ),
                                    //ontap setstate to get time
                                    onTap: () async {
                                      //_showIni(context);
                                      TimeOfDay? pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(hour: selectedDay.hour, minute: selectedDay.minute),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Color(0xFF9296BB),
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Color(0xFF9296BB),
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
                                      selectedDay = newPickedDate;
                                      setState(() {});
                                    },
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
                                        "MODIFICAR RECORDATORIO",
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
                                      widget.reminder.message = controllerMessage.text;
                                      widget.reminder.reminderDate = DateFormat('yyyy-MM-dd HH:mm').format(selectedDay);
                                      await dataBaseHelper.updateReminder(
                                        widget.userId,
                                        userName.toString(),
                                        password.toString(),
                                        widget.reminder,
                                      ).then((value) => Alert(
                                        context: context, type: AlertType.success,
                                        title: "MODIFICACI??N EXITOSA",
                                        desc: "??Se modific?? con ??xito su recordatorio!",
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
            ],
          ),
        ),
      ),
    );
  }
}
