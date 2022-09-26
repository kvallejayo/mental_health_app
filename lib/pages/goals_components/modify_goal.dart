// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';
import '../../models/Goal.dart';
import '../../security/user_secure_storage.dart';
import '../../themes/my_colors.dart';
import '../../utils/endpoints.dart';
import 'goals.dart';

class ModifyGoal extends StatefulWidget {
  final String userId;
  Goal goal;
  ModifyGoal({Key? key, required this.userId, required this.goal}) : super(key: key);

  @override
  State<ModifyGoal> createState() => _ModifyGoalState();
}

class _ModifyGoalState extends State<ModifyGoal> {

  TextEditingController controllerObjectiveTitle = TextEditingController();
  TextEditingController controllerActionPlan1 = TextEditingController();
  TextEditingController controllerActionPlan2 = TextEditingController();
  TextEditingController controllerActionPlan3 = TextEditingController();

  String selectedGoalType = "";
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  @override
  void initState() {
    controllerObjectiveTitle.text = widget.goal.message;
    selectedGoalType = widget.goal.type;
    controllerActionPlan1.text = widget.goal.actionPlan1;
    controllerActionPlan2.text = widget.goal.actionPlan2;
    controllerActionPlan3.text = widget.goal.actionPlan3;
    super.initState();
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
                    TitleHeader("Modificar Objetivo"),
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
                              "MODIFICAR OBJETIVO",
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

                            widget.goal.message = controllerObjectiveTitle.text;
                            widget.goal.type = selectedGoalType;
                            widget.goal.actionPlan1 = controllerActionPlan1.text;
                            widget.goal.actionPlan2 = controllerActionPlan2.text;
                            widget.goal.actionPlan3 = controllerActionPlan3.text;

                            Goal goal = await dataBaseHelper.updateGoal(
                              widget.userId,
                              userName.toString(),
                              password.toString(),
                              widget.goal,
                            );

                            if (goal == null) {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "MODIFICACIÓN FALLIDA",
                                desc: "Vuelva a modificar los datos.",
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
                                title: "MODIFICACIÓN EXITOSA",
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
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
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
