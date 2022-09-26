// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/models/Thoughts.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';
import '../../components/my_input_field.dart';
import '../../security/user_secure_storage.dart';
import '../../themes/my_colors.dart';
import '../../utils/endpoints.dart';

class ModifyThought extends StatefulWidget {
  final String userId;
  Thought thought;
  ModifyThought({Key? key, required this.userId, required this.thought}) : super(key: key);

  @override
  State<ModifyThought> createState() => _ModifyThoughtState();
}

class _ModifyThoughtState extends State<ModifyThought> {
  TextEditingController controllerSituation = TextEditingController();
  TextEditingController controllerThoughts = TextEditingController();
  TextEditingController controllerActions = TextEditingController();
  TextEditingController controllerTipForFriend = TextEditingController();
  List<dynamic> moodsFelt = [];
  String selectedGoalType = "";
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future init() async {

  }

  @override
  void initState() {
    controllerSituation.text = widget.thought.situation;
    controllerThoughts.text = widget.thought.thoughts;
    controllerActions.text = widget.thought.actions;
    controllerTipForFriend.text = widget.thought.tipForFriend;
    moodsFelt = widget.thought.moodsFelt;

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
                Image.asset('assets/ilustraciones/thoughts.png'),
              ],
            ),
            SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  TitleHeader("Pensamientos"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        H1Label("Modificar Pensamiento"),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Describe la situación",
                            controller: controllerSituation,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "¿Qué pensamientos tuviste durante la situación?",
                            controller: controllerThoughts,
                          ),
                        ),
                        H1Label("¿Que emoción sentiste?"),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: MoodPicker(),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "¿Qué acciones tomaste?",
                            controller: controllerActions,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Si la situación le estaría pasando a un amigo, ¿Qué le aconsejarías?",
                            controller: controllerTipForFriend,
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
                              "MODIFICAR PENSAMIENTO",
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

                            widget.thought.situation = controllerSituation.text;
                            widget.thought.thoughts = controllerThoughts.text;
                            widget.thought.actions = controllerActions.text;
                            widget.thought.tipForFriend = controllerTipForFriend.text;
                            widget.thought.moodsFelt = moodsFelt;

                            await dataBaseHelper.updateThought(
                              widget.userId,
                              userName.toString(),
                              password.toString(),
                              widget.thought,
                            ).then((value) => Alert(
                              context: context,
                              type: AlertType.success,
                              title: "MODIFICACIÓN EXITOSA",
                              desc: "¡Se modificó con éxito su pensamiento!",
                              buttons: [
                                DialogButton(
                                  width: 120,
                                  color: waterGreen,
                                  child: Text(
                                    "Aceptar",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    print(value);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ).show());

                            setState(() {
                              controllerSituation.text = "";
                              controllerThoughts.text = "";
                              controllerActions.text = "";
                              controllerTipForFriend.text = "";
                              moodsFelt = [];
                            });

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }
  Future<Color?> getColorFromImage(String imgPath) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      AssetImage(imgPath),size: Size(200,100),
    );
    return generator.dominantColor != null ? generator.dominantColor?.color : waterGreen;
  }

  Widget MoodPicker() {
    double iconSize = 45;
    List<PaletteColor> colors = [];
    List<dynamic> moods = ["Happy", "Scare", "Sad", "Angry", "Disgust"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for(int i = 0; i < moods.length; i++)
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: moodsFelt.contains(moods[i]) ? waterGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: Image.asset('assets/sentimientos/${moods[i].toLowerCase()}.png'),
                  iconSize: iconSize,
                  onPressed: () async {
                    setState(() { });
                    moodsFelt.contains(moods[i]) ? moodsFelt.remove(moods[i]) : moodsFelt.add(moods[i]);
                    /*
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: await getColorFromImage('assets/sentimientos/${moods[i].toLowerCase()}.png'),
                      content: Text(
                        "Seleccionando ${moods[i]}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));

                     */
                  },
                ),
              ),
              Text(
                moods[i],
                style: TextStyle(
                  color: Color.fromRGBO(115, 112, 108, 10),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
