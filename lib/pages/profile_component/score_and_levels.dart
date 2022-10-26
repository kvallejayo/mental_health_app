// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mental_health_app/Components/my_labels.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';

class ScoreAndLevels extends StatelessWidget {
  final String userId;
  late Map<String,dynamic> profileData;

  ScoreAndLevels({Key? key, required this.userId}) : super(key: key);

  List<dynamic> levels = [
    {
      "tag_img": "assets/niveles/principiante motivado.png",
      "required_score": 50,
    },
    {
      "tag_img": "assets/niveles/perseverante destacado.png",
      "required_score": 200,
    },
    {
      "tag_img": "assets/niveles/productivo sobresaliente.png",
      "required_score": 500,
    },
    {
      "tag_img": "assets/niveles/experto inspirador.png",
      "required_score": 1000,
    },
  ];

  Future<Map<String, dynamic>> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);

    if(userData["profileData"] == null){
      return {};
    }
    return userData["profileData"];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/profile.png'),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/niveles/niveles.png", width: 200),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Niveles y Puntaje"),

                  FutureBuilder(
                    future: getProfile(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot){
                      if(!snapshot.hasData){
                        return SizedBox();
                      }
                      profileData = snapshot.data;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            H1Label("Tu nivel"),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(profileData["profile_img"], width: 100,),
                                    Text(
                                      profileData["username"],
                                      style: TextStyle(
                                        color: Color(0xFF9F9F9F),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image.asset(profileData["ranked_img"], width: 200,),
                                    SizedBox(height: 5,),
                                    Container(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            profileData["score"].toString(),
                                            style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF66656C),
                                            ),
                                          ),
                                          Text(
                                            "Puntaje",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF66656C),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            H1Label("Niveles"),
                            Column(
                              children: [
                                for(int i = 0; i < levels.length; i++)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(levels[i]["tag_img"], width: 220,),
                                          Container(
                                            width: 70,
                                            child: Text(
                                              levels[i]["required_score"].toString(),
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        idSend: userId,
        isTheSameChatMindy: true,
        mindyColorIcon: false,
      ),
    );
  }
}
