// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/models/AnxietyQuizModels.dart';
import 'package:mental_health_app/pages/quiz_component/quiz_results_page.dart';

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
          String message;
          if (_score < 5){
            message = "De acuerdo con tus resultados tu nivel de ansiedad es mínima. No te olvides de realizar ejercicios de relajación 😊";
          } else if (_score >= 5 && _score < 10) {
            message = "De acuerdo con tus resultados tu nivel de ansiedad es leve. No te olvides de realizar ejercicios de relajación y ejercicios físicos 😊";
          } else if (_score >= 10 && _score < 15) {
            message = "De acuerdo con tus resultados tu nivel de ansiedad es moderada. Trabajemos en identificar cuáles son los factores que te generan estrés, llevar un registro de estos es importante para mejorar nuestro estado mental ";
          } else {
            message = "De acuerdo con tus resultados tu nivel de ansiedad es severa. Es normal que sientas miedo, pero recuerda que no estás solo y siempre puedes buscar ayuda profesional. Te recomiendo reservar una cita con un psicólogo en la sede a la que perteneces";
          }

          Map<String, dynamic> newQuizResults = {
            "type": "Test de ansiedad",
            "score": _score,
            "message": message,
            "date": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
          };

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultsPage(userId: widget.idSend, quizResults: newQuizResults),
            ),
          );
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