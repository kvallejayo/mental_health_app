// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';
import '../../themes/my_colors.dart';

class QuizRecords extends StatefulWidget {
  final String userId;
  final String username;
  const QuizRecords({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  State<QuizRecords> createState() => _QuizRecordsState();
}

class _QuizRecordsState extends State<QuizRecords> {
  List<dynamic> quizesList = [];

  Future<List<dynamic>> getQuizesList() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);
    print(userData["quizzesResults"]);
    return userData["quizzesResults"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/objetivo.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Historial"),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getQuizesList(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot){
                            if(snapshot.hasData){
                              quizesList = snapshot.data;
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            width: 250,
                                            decoration: BoxDecoration(
                                              color: lightWaterGreen,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            padding: EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text("¡Hola ${widget.username}! Recuerda que estos test no son diagnósticos oficiales. Son test de autopercepción que nos ayudan a tener una guía del posible estado que nos encontramos. Te recomendamos compartir estos resultados con un profesional de la salud mental para ayudarte a interpretarlos mejor."),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.topCenter,
                                                child: Image.asset("assets/bot_emocionado.png", width: 100,),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Mindy",
                                                  style: TextStyle(
                                                    color: Color(0xFF7C7C88),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  QuizzesListView(
                                    quizzesList: quizesList,
                                  ),
                                  SizedBox(height: 10,),
                                  //FinishedObjectivesList(context),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }
  Widget QuizzesListView({required List<dynamic> quizzesList}) {

    if (quizzesList.isEmpty){
      return Center(
        child: Text(
          "Aún no tienes objetivos en esta lista",
          style: TextStyle(fontSize: 18, color: Colors.grey,),
        ),
      );
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: quizzesList.length,
        itemBuilder: (context, index){
          //solo construye items si es que el length es mayor a 0

          return Container(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
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
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      quizzesList[index]["type"],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          quizzesList[index]["message"],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          DateFormat.yMMMMd("es_US").add_jm().format(DateTime.parse(quizzesList[index]["date"])),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(height: 10,),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
