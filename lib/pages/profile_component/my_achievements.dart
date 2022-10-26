// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';

class MyAchievements extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> profileData;
  const MyAchievements({Key? key, required this.userId, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage("assets/fondos/chatbot.png"),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Mis Logros"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        H1Label("Tu nivel"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(profileData["ranked_img"], width: 230,),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    profileData["score"].toString(),
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF66656C),
                                    ),
                                  ),
                                  Text(
                                    "Puntaje",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF66656C),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        H1Label("Medallas Obtenidas"),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15,),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: profileData["medals"].length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                child: Center(
                                  child: Image.asset(profileData["medals"][index]["image"]),
                                ),
                                onTap: (){

                                },
                              );
                            },
                          ),
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
      bottomNavigationBar: BottomNavigation(
        isTheSameProfile: true,
        profileColorIcon: false,
        idSend: userId,
      ),
    );
  }
}
