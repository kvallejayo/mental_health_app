// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/Components/my_labels.dart';

import '../../Components/bottom_navigation_bar.dart';

class Medals extends StatelessWidget {
  final String userId;
  Medals({Key? key, required this.userId}) : super(key: key);

  List<dynamic> medals = [
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
    {
      "title": "test",
      "image": "assets/medals/medal_temp.png",
    },
  ];

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
                  TitleHeader("Colección de Medallas"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: medals.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          child: Center(
                            child: Image.asset(medals[index]["image"]),
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
      bottomNavigationBar: BottomNavigation(
        idSend: userId,
        isTheSameChatMindy: true,
        mindyColorIcon: false,
      ),
    );
  }
}
