// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/pages/learn_component/learn.dart';
import 'package:mental_health_app/themes/my_colors.dart';

final tips = [
  '1. Reconoce tus emociones',
  '2. Piensa en lo que puedes hacer para distraerte',
  'Tips para una mejor organización',
  '¿Cómo manejar mi enojo?',
  '10 consejos para cuidar tu salud mental',
  '¿La salud mental puede afectar en mis estudios?',
];
final strings = [
  'Entender cómo te sientes es importante. No ignores tus sentimientos. Sentir tristeza o enojo es normal, no te exijas estar siempre positivo o feliz. Escribir sobre tus sentimientos puede ayudarte a comprenderlos de mejor manera. Escribe en un papel o haz notas mentales expresando cómo te hace sentir tu nueva rutina diaria.',
  'Cocina, baila, mira películas, lee un libro, participa en retos o challenges saludables, ejercítate desde casa o juega con tus amigos en línea. Haz cosas que te hagan feliz. Crear distracciones es una buena forma de lidiar con la tensión emocional.',

];
class RecommendationsDetailsView extends StatefulWidget {
  final String idSend;
  final Map<String, dynamic> recommendation;
  RecommendationsDetailsView({ required this.idSend, required this.recommendation });
  @override
  State<RecommendationsDetailsView> createState() => _RecommendationsDetailsViewState();
}

class _RecommendationsDetailsViewState extends State<RecommendationsDetailsView> {

  late Timer _timer;
  late double _progress1;
  late int recommendationIndex;

  @override
  void initState() {
    recommendationIndex = 0;
    _progress1 = 0;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_progress1 == 1) {
            timer.cancel();
            //QUE HACER CUANDO SE VENCE EL PLAZO
            Navigator.pop(context);
          } else {
            _progress1 += 0.2;
          }
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Color.fromRGBO(254, 246, 238, 10),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 5,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                      value: _progress1,
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    widget.recommendation["title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: strongPurple,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(232, 227, 238, 10),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(widget.recommendation["content"]),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.recommendation["image"]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}