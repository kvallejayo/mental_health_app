// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/bottom_navigation_bar.dart';

class QuizResultsPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> quizResults;
  const QuizResultsPage({Key? key, required this.userId, required this.quizResults}) : super(key: key);

  Future<void> saveResult() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);

    if(userData["quizzesResults"] == null){
      userData["quizzesResults"] = [];
    }
    userData["quizzesResults"].add(quizResults);
    print(userData["quizzesResults"]);
    await pref.setString(userId, jsonEncode(userData));
  }

  @override
  Widget build(BuildContext context) {
    saveResult();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/fondos/home.png'
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "¡Está listo el resultado del test de autopercepción!",
                      style: TextStyle(
                        color: Color(0xFF9296BB),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Image.asset("assets/botImage.png", width: 180,),
                  SizedBox(height: 10,),
                  Text(
                    "Mindy",
                    style: TextStyle(
                      color: Color(0xFF7C7C88),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    width: 300,
                    child: Text(
                      quizResults["message"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFDFDEEC),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    child: Container(
                      child: Text(
                        "VOLVER A TOMAR OTRO TEST",
                        style: TextStyle(
                          color: Color(0xFF686EAE),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameQuiz: true,
        quizColorIcon: false,
        idSend: userId,
      ),
    );
  }
}
