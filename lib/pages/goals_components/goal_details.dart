// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mental_health_app/models/Goal.dart';

import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/components/my_input_field.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

class GoalDetails extends StatelessWidget {
  final String userId;
  Goal goal;
  GoalDetails({
    Key? key,
    required this.userId,
    required this.goal,
  }) : super(key: key);

  TextEditingController controllerObjectiveTitle = TextEditingController();
  TextEditingController controllerActionPlan1 = TextEditingController();
  TextEditingController controllerActionPlan2 = TextEditingController();
  TextEditingController controllerActionPlan3 = TextEditingController();
  String selectedGoalType = "";
  DataBaseHelper dataBaseHelper = DataBaseHelper();


  @override
  Widget build(BuildContext context) {
    controllerObjectiveTitle.text = goal.message;
    selectedGoalType = goal.type;
    controllerActionPlan1.text = goal.actionPlan1;
    controllerActionPlan2.text = goal.actionPlan2;
    controllerActionPlan3.text = goal.actionPlan3;

    Color goalTypeColor = Colors.white;
    switch (goal.type) {
      case "Corto Plazo": goalTypeColor = goal.status == "Pending" ? Color(0xFFB999D2) : Color(0xFFB2AABF); break;
      case "Medio Plazo": goalTypeColor = goal.status == "Pending" ? Color(0xFF63A8E9) : Color(0xFFB2AABF); break;
      case "Largo Plazo": goalTypeColor = goal.status == "Pending" ? Color(0xFF8ED1AB) : Color(0xFFB2AABF); break;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/objetivo.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/pantallas/nuevo objetivo.png'),
              ],
            ),

            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    TitleHeader("Modificar Objetivo"),
                    Column(
                      children: [
                        H1Label("Mi Objetivo"),

                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(15.0),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: goalTypeColor,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          goal.type,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        goal.message,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        H1Label("Plan de Acción"),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "¿Cuál será tu primer paso?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: MyInputField(
                            controller: controllerActionPlan1,
                            enabled: false,
                            backgroundColor: Colors.white,
                            hintInsteadOfLabel: true,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "¿Qué harás para cumplirlo?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            controller: controllerActionPlan2,
                            enabled: false,
                            backgroundColor: Colors.white,
                            hintInsteadOfLabel: true,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "¿Cómo controlarás tu constancia?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            controller: controllerActionPlan3,
                            enabled: false,
                            backgroundColor: Colors.white,
                            hintInsteadOfLabel: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: userId),
    );
  }
}
