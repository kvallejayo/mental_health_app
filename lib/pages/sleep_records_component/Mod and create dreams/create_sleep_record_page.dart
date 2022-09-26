// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/components/my_input_field.dart';
import 'package:mental_health_app/models/SleepRecord.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

import '../../../themes/my_colors.dart';

class CreateSleepRecordPage extends StatefulWidget {
  final String idSend;
  CreateSleepRecordPage(this.idSend);

  @override
  State<CreateSleepRecordPage> createState() => _CreateSleepRecordPageState();
}

class _CreateSleepRecordPageState extends State<CreateSleepRecordPage> {

  final TextEditingController controllerDescription = TextEditingController();
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future init() async {

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              BackgroundImage('assets/fondos/sueño.png'),
              Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                child: Image.asset("assets/graficas/vista_dibujo_sueño.png"),
              ),
              Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10,),

                      TitleHeader("Registro de sueño"),

                      Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [

                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Nuevo registro de sueño",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9296BB),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 30,),

                            MyInputField(
                              controller: controllerDescription,
                              labelText: "Descripción del sueño",
                              backgroundColor: Colors.white,
                            ),

                            SizedBox(height: 20,),

                            // PICK START DATE AND TIME
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DateAndTimePicker(
                                      "Fecha Inicial",
                                      "Hora Inicial",
                                          (pickedDate){
                                        startDate = pickedDate;
                                        setState(() { });
                                      },
                                      startDate,
                                    ),
                                    SizedBox(width: 20,),
                                    Container(
                                      height: 85,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage("assets/graficas/sueño_noche.png"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 25),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 85,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage("assets/graficas/sueño_día.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    DateAndTimePicker(
                                      "Fecha Final",
                                      "Hora Final",
                                          (pickedDate){
                                        endDate = pickedDate;
                                        setState(() { });
                                      },
                                      endDate,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 35),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: waterGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(13),
                                child: Text(
                                  "REGISTRAR HORAS",
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onPressed: () async {

                                final username = await UserSecureStorage.getUsername() ?? '';
                                final password = await UserSecureStorage.getPassword() ?? '';

                                String strStartDate = DateFormat('yyyy-MM-dd HH:mm').format(startDate);
                                String strEndDate = DateFormat('yyyy-MM-dd HH:mm').format(endDate);

                                SleepRecord sleepRecord = SleepRecord(
                                  startDate: strStartDate,
                                  endDate: strEndDate,
                                  message: controllerDescription.text,
                                );
                                await dataBaseHelper.createASleepRecord(
                                    widget.idSend,
                                    username,
                                    password,
                                    sleepRecord
                                ).then((value) => Alert(
                                  context: context, type: AlertType.success,
                                  title: "CREACIÓN EXITOSA",
                                  desc: "¡Se registró con exito sus horas de sueño!",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget DateAndTimePicker(
      String dateLabel,
      String timeLabel,
      Function(DateTime)? onPickedDate,
      DateTime date,
      ){

    String hours = date.hour.toString().padLeft(2, '0');
    String minutes = date.minute.toString().padLeft(2, '0');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 220,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373057),
                  ),
                ),
              ),

              Container(
                width: 120,
                padding: EdgeInsets.all(3),
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: darkPurple,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.yMd("es_US").format(date),
                            style: TextStyle(color: darkPurple),
                          ),
                          SizedBox(width: 4,),
                          Icon(Icons.calendar_month, color: darkPurple,),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
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

                    if (pickedDate == null) return;

                    final newPickedDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      date.hour,
                      date.minute,
                    );
                    onPickedDate!(newPickedDate);
                  },
                ),
              ),


            ],
          ),
        ),

        SizedBox(height: 5,),

        Container(
          width: 220,
          child: Row(
            children: [
              Container(
                width: 100,
                child: Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373057),
                  ),
                ),
              ),

              Container(
                width: 120,
                padding: EdgeInsets.all(3),
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: darkPurple,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.jm("es_US").format(date),
                            style: TextStyle(color: darkPurple,
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.watch_later_outlined,
                            color: darkPurple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {

                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
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
                      date.year,
                      date.month,
                      date.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    onPickedDate!(newPickedDate);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

