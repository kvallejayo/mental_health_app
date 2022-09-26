// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/Goal.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/themes/my_colors.dart';
import 'package:mental_health_app/utils/endpoints.dart';

class CreateGoal extends StatefulWidget {
  final String idSend;

  CreateGoal(this.idSend);
  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  TextEditingController controllerObjectiveTitle = TextEditingController();
  TextEditingController controllerActionPlan1 = TextEditingController();
  TextEditingController controllerActionPlan2 = TextEditingController();
  TextEditingController controllerActionPlan3 = TextEditingController();

  String selectedGoalType = "";
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future init() async {

  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
                    TitleHeader("Nuevo Objetivo"),
                    Column(
                      children: [
                        H1Label("Objetivo"),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Escribir objetivo...",
                            controller: controllerObjectiveTitle,
                          ),
                        ),
                        H1Label("Tipo de Objetivo"),
                        GoalTypePicker(context),

                        H1Label("Plan de Acción"),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "¿Cuál será tu primer paso?",
                            controller: controllerActionPlan1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "¿Qué harás para cumplirlo?",
                            controller: controllerActionPlan2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "¿Cómo controlarás tu constancia?",
                            controller: controllerActionPlan3,
                          ),
                        ),
                        SizedBox(height: 20,),
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
                              "CREAR OBJETIVO",
                              style: TextStyle(
                                fontSize: 15.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var userName = await UserSecureStorage.getUsername();
                            var password = await UserSecureStorage.getPassword();

                            Goal goal = Goal(
                                type: selectedGoalType,
                                message: controllerObjectiveTitle.text,
                                actionPlan1: controllerActionPlan1.text,
                                actionPlan2: controllerActionPlan2.text,
                                actionPlan3: controllerActionPlan3.text,
                                startDate: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                                status: "Pending"
                            );

                            goal = await dataBaseHelper.createGoal(
                              widget.idSend,
                              userName.toString(),
                              password.toString(),
                              goal,
                            );

                            if (goal == null) {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "CREACIÓN FALLIDA",
                                desc: "Vuelva a guardar los datos completos, otra vez",
                                buttons: [
                                  DialogButton(
                                    width: 120,
                                    child: Text(
                                      "Volver",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ).show();
                            } else {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "CREACIÓN EXITOSA",
                                desc: "¡Se guardó con éxito su objetivo!",
                                buttons: [
                                  DialogButton(
                                    width: 120,
                                    color: waterGreen,
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ).show();
                            }
                          },
                        ),
                        //Buttom("CREAR OBJETIVO"),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.idSend),
    );
  }

  Widget GoalTypePicker(BuildContext context) {

    List<Map<String, dynamic>> goalTypesList = [
      {
        "title": "Corto Plazo",
        "color": Color(0xFFB999D2),
      },
      {
        "title": "Medio Plazo",
        "color": Color(0xFF63A8E9),
      },
      {
        "title": "Largo Plazo",
        "color": Color(0xFF8ED1AB),
      },
    ];

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < goalTypesList.length; i++)
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: goalTypesList[i]["color"],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  goalTypesList[i]["title"],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                selectedGoalType = goalTypesList[i]["title"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  backgroundColor: goalTypesList[i]["color"],
                  content: Text(
                    "Seleccionado: $selectedGoalType",
                    style: TextStyle(color: Colors.white),
                  ),
                ));
              },
            ),
        ],
      ),
    );
  }

  Widget MyInputField({
    required String labelText,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    Color backgroundColor = const Color(0xFFE8E3EE),
    Color borderColor = const Color(0xFF7115D3),
    Color labelColor = const Color(0xFF9996B7),
    bool isPasswordField = false,
    bool obscureText = false,
  }) {
    controller.addListener(() {setState(() {});});
    late Widget suffixIcon;
    if (isPasswordField){
      obscureText = true;
      suffixIcon = controller.text.isEmpty ? Container(width: 0,): IconButton(
        icon: Icon(Icons.close, color: borderColor,),
        onPressed: (){ controller.clear(); },
      );

      /*
      suffixIcon = IconButton(
        icon: isPasswordVisible ? Icon(Icons.visibility_off, color: borderColor,) : Icon(Icons.visibility, color: borderColor),
        onPressed: (){
          print(obscureText);
          setState(() {
            obscureText = !obscureText;
          });
        },
      );

       */
    } else {
      suffixIcon = controller.text.isEmpty ? Container(width: 0,): IconButton(
        icon: Icon(Icons.close, color: borderColor,),
        onPressed: (){ controller.clear(); },
      );
    }
    return TextField(
      keyboardType: inputType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: backgroundColor,
        filled: true,
        hintText: labelText,
        hintStyle: TextStyle(
          color: labelColor,
          fontSize: 18,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 2,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
