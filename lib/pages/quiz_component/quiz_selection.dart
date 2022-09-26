// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../Components/bottom_navigation_bar.dart';
import 'anxiety_quiz.dart';
import 'depression_quiz.dart';

class QuizSelection extends StatelessWidget {

  final String idSend;
  final String username;

  const QuizSelection({
    Key? key,
    required this.idSend,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Autopercepción",
                          style: TextStyle(
                            color: Color.fromRGBO(67, 58, 108, 10),
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 410,
                    child: Divider(
                      color: Color.fromRGBO(146, 150, 187, 10),
                      thickness: 1,
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/botImage.png", width: 180,),

                        SizedBox(height: 25,),
                        Text(
                          "¡Hola $username!",
                          style: TextStyle(
                            color: Color(0xFF615987),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "¿Cuál test te gustaría comenzar",
                          style: TextStyle(
                            color: Color(0xFF9296BB),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25,),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(107, 174, 174, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(13),
                            child: Text(
                              "Test de Ansiedad",
                              style: TextStyle(
                                fontSize: 15.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AnxietyQuiz(idSend: idSend,),),
                            );
                          },
                        ),

                        SizedBox(height: 15,),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(107, 174, 174, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(13),
                            child: Text(
                              "Test de Tristeza",
                              style: TextStyle(
                                fontSize: 15.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DepressionQuiz(idSend: idSend,),),
                            );
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
      bottomNavigationBar: BottomNavigation(
        isTheSameQuiz: true,
        quizColorIcon: false,
        idSend: idSend,
      ),
    );
  }
}