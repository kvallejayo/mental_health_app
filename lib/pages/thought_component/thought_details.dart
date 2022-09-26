// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mental_health_app/models/Thoughts.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';
import '../../components/my_input_field.dart';
import '../../themes/my_colors.dart';

class ThoughtDetails extends StatelessWidget {
  final Thought thought;
  final String userId;
  ThoughtDetails({Key? key, required this.thought, required this.userId}) : super(key: key);

  TextEditingController controllerSituation = TextEditingController();
  TextEditingController controllerThoughts = TextEditingController();
  TextEditingController controllerActions = TextEditingController();
  TextEditingController controllerTipForFriend = TextEditingController();
  List<dynamic> moodsFelt = [];

  @override
  Widget build(BuildContext context) {
    controllerSituation.text = thought.situation;
    controllerThoughts.text = thought.situation;
    controllerActions.text = thought.situation;
    controllerTipForFriend.text = thought.situation;
    moodsFelt = thought.moodsFelt;

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
                        H1Label("Mi Pensamiento"),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Descripción de la situación",
                            controller: controllerSituation,
                            enabled: false,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Pensamientos que tuviste durante la situación",
                            controller: controllerThoughts,
                            enabled: false,
                          ),
                        ),
                        H1Label("Emociones que sentiste"),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: MoodPicker(),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Acciones que tomaste",
                            controller: controllerActions,
                            enabled: false,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: MyInputField(
                            labelText: "Tu consejo para un amigo",
                            controller: controllerTipForFriend,
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: userId),
    );
  }

  Widget MoodPicker() {
    double iconSize = 45;

    List<dynamic> moods = thought.moodsFelt;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for(int i = 0; i < moods.length; i++)
          Column(
            children: [
              IconButton(
                icon: Image.asset('assets/sentimientos/${moods[i].toLowerCase()}.png'),
                iconSize: iconSize,
                onPressed: () async {
                },
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
