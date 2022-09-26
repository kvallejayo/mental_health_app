// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mental_health_app/models/AnxietyQuizModels.dart';

import '../../Components/bottom_navigation_bar.dart';

class AnxietyQuiz extends StatefulWidget {
  final String idSend;

  AnxietyQuiz({
    Key? key,
    required this.idSend,
  }) : super(key: key);

  @override
  State<AnxietyQuiz> createState() => _AnxietyQuizState();
}

class _AnxietyQuizState extends State<AnxietyQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 1,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/fondos/home.png'
                ),
              ),
            ),
          ),
          QuestionWidget(idSend: widget.idSend,)
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameQuiz: true,
        quizColorIcon: false,
        idSend: widget.idSend,
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {

  final String idSend;

  const QuestionWidget({Key? key, required this.idSend}) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late PageController _controller;
  int _questionNumber = 1;
  int _score = 0;
  bool hasSelectedOption = false;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 75),
          Text('Pregunta $_questionNumber/${questions.length}'),
          const Divider(thickness: 1, color: Colors.teal),
          Expanded(
            child: PageView.builder(
              itemCount: questions.length,
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                currentQuestionIndex = index;
                final _question = questions[index];
                return buildQuestion(_question);
              },
            ),
          ),

          hasSelectedOption ? buildElevatedButton(questions[currentQuestionIndex]) : const SizedBox.shrink(),
          const SizedBox(height: 20),
        ],
      )
    );
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 18),

        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: 80,
                child: Image.asset("assets/botImage.png"),
              ),
            ),
            Flexible(
              child: Text(
                question.text,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),

        SizedBox(height: 18),

        Expanded(
          child:OptionsWidget(
            question: question,
            onClickedOption: (option) {
              setState(() {
                question.selectedOption = option;
                print(option.text);
              });
              hasSelectedOption = true;
              //_score += question.selectedOption!.points;
            },
          )
        )
      ],
    );
  }
  ElevatedButton buildElevatedButton(Question question) {
    return ElevatedButton(
      child: Text(_questionNumber < questions.length ? 'Siguiente Página' : 'Ver el resultado'),
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(104, 174, 174, 1.0),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: () {
        if(_questionNumber < questions.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _score += question.selectedOption!.points;
            _questionNumber++;
            hasSelectedOption = false;
          });
        } else {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ResultPage(score: _score, idSend: widget.idSend,),),);
        }
      },
    );
  }
}


class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({Key? key, required this.question, required this.onClickedOption}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: question.options.map((option) => buildOption(context, option)).toList(),
    ),
  );

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
        onTap: () => onClickedOption(option),
        child: Container(
            height:50,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  option.text,
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

Color getColorForOption(Option option, Question question) {
  final isSelected = option == question.selectedOption;

  if(isSelected) {
    return Colors.teal;
  }

  return Color.fromRGBO(104, 174, 174, 1.0);
}

class ResultPage extends StatelessWidget {

  final String idSend;
  final int score;
  late String message = "";

  ResultPage({Key? key, required this.score, required this.idSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (score < 5){
      message = "De acuerdo con tus resultados tu nivel de ansiedad es mínima. No te olvides de realizar ejercicios de relajación 😊";
    } else if (score >= 5 && score < 10) {
      message = "De acuerdo con tus resultados tu nivel de ansiedad es leve. No te olvides de realizar ejercicios de relajación y ejercicios físicos 😊";
    } else if (score >= 10 && score < 15) {
      message = "De acuerdo con tus resultados tu nivel de ansiedad es moderada. Trabajemos en identificar cuáles son los factores que te generan estrés, llevar un registro de estos es importante para mejorar nuestro estado mental ";
    } else {
      message = "De acuerdo con tus resultados tu nivel de ansiedad es severa. Es normal que sientas miedo, pero recuerda que no estás solo y siempre puedes buscar ayuda profesional. Te recomiendo reservar una cita con un psicólogo en la sede a la que perteneces";
    }

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
                      message,
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
        idSend: idSend,
      ),
    );
  }
}


