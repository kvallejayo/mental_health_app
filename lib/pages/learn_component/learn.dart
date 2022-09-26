// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/pages/learn_component/recommendations_details_view.dart';

class LearnPage extends StatefulWidget {
  final String userId;

  LearnPage(this.userId);
  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {

  final recommendationsImgs = [
    "assets/learn/estudios salud.png",
    "assets/learn/salud mental principal.png",
    "assets/learn/productividad consejo.png",
  ];
  final tipsImgs = [
    "assets/learn/como superar.png",
    "assets/learn/registro de pensamientos.png",
    "assets/learn/procrastinacion.png",
    "assets/learn/inteligencia emocional.png",
    "assets/learn/deficit atencion.png",
    "assets/learn/toc.png",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              BackgroundImage('assets/fondos/info.png'),
              SingleChildScrollView(
                child: Column(
                  children: [
                    TitleHeader("Aprende algo nuevo"),
                    Column(
                      children: [
                        H1Label("Recomendaciones para ti"),
                        CarouselSlider(
                          items: [
                            for (var recommendationImg in recommendationsImgs)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecommendationsDetailsView(widget.userId),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(recommendationImg),
                                ),
                              ),
                          ],
                          options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayCurve: Curves.easeInOut,
                            scrollDirection: Axis.horizontal,
                            viewportFraction: 0.5,
                          ),
                        ),

                        SizedBox(height: 10,),

                        H1Label("Psicología"),

                        SizedBox(height: 10,),

                        GestureDetector(
                          child: Image.asset("assets/learn/que es cbt.png", width: 350,),
                          onTap: (){},
                        ),
                        GestureDetector(
                          child: Image.asset("assets/learn/gad.png", width: 350,),
                          onTap: (){},
                        ),
                        GestureDetector(
                          child: Image.asset("assets/learn/phq.png", width: 350,),
                          onTap: (){},
                        ),

                        H1Label("Nuevos conocimientos"),

                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            for (var tipImg in tipsImgs)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  height: 120,
                                  width: MediaQuery.of(context).size.width / 3.7,
                                  child: Image.asset(tipImg),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameLearn: true,
        learnColorIcon: false,
        idSend: widget.userId,
      ),
    );
  }
}
