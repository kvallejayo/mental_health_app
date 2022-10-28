// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/Components/my_labels.dart';
import 'package:mental_health_app/models/Medal.dart';

import '../../Components/bottom_navigation_bar.dart';

class Medals extends StatelessWidget {
  final String userId;
  Medals({Key? key, required this.userId}) : super(key: key);

  List<Medal> medals = [
    Medal(
      message: "1 día usando la aplicación",
      image: "assets/medals/days_in_mindy_1.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "3 días usando la aplicación",
      image: "assets/medals/days_in_mindy_3.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "7 días usando la aplicación",
      image: "assets/medals/days_in_mindy_7.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "15 días usando la aplicación",
      image: "assets/medals/days_in_mindy_15.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "1 mes usando la aplicación",
      image: "assets/medals/days_in_mindy_1_month.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "3 meses usando la aplicación",
      image: "assets/medals/days_in_mindy_3_months.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "6 meses usando la aplicación",
      image: "assets/medals/days_in_mindy_6_months.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
    Medal(
      message: "1 año usando la aplicación",
      image: "assets/medals/days_in_mindy_1_year.png",
      earnCondition: (){ return true;},
      pointsWorth: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if(medals[0].earnCondition()){
      print("OMFG");
    }
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
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(medals[index].image),
                            ),
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
