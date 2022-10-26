// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mental_health_app/Components/my_labels.dart';

import '../../Components/bottom_navigation_bar.dart';
import '../../themes/my_colors.dart';

class NotificationsSettings extends StatefulWidget {
  final String userId;
  const NotificationsSettings({Key? key, required this.userId}) : super(key: key);

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {

  List<dynamic> notificationsSettings = [
    {
      "title": "Recibir notificaciones diarias",
      "value": true,
    },
    {
      "title": "Recibir afirmaciones positivas",
      "value": true,
    },
    {
      "title": "Recibir alertas de uso",
      "value": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/fondos/home.png'
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Notificaciones"),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/bot_emocionado.png", width: 150,),
                        SizedBox(height: 10,),
                        Text(
                          "Mindy",
                          style: TextStyle(
                            color: Color(0xFF7C7C88),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          width: 300,
                          child: Text(
                            "Las notificaciones activadas permiten que pueda avisarte al uso continuo de la aplicación. También, podré ayudarte a recordar tus pendientes asignados en tus recordatorios como las afirmaciones positivas según las horas guardadas.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDFDEEC),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        SizedBox(height: 15,),
                        H1Label("Configuración"),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notificationsSettings.length,
                          itemBuilder: (context, index){
                            return SwitchListTile(
                              title: Text(notificationsSettings[index]["title"]),
                              value: notificationsSettings[index]["value"],
                              activeColor: Color(0xFF8ED1AB),
                              onChanged: (bool value){
                                setState(() {
                                  notificationsSettings[index]["value"] = value;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameProfile: true,
        profileColorIcon: false,
        idSend: widget.userId,
      ),
    );
  }
}
