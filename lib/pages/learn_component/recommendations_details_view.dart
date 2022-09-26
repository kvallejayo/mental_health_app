// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/pages/learn_component/learn.dart';

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
  RecommendationsDetailsView(this.idSend);
  @override
  State<RecommendationsDetailsView> createState() => _RecommendationsDetailsViewState();
}

class _RecommendationsDetailsViewState extends State<RecommendationsDetailsView> {
  late Timer _timer;
  @override
  void initState() {
    _progress1 == 0;
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => setState(() {
              if (_progress1 == 1) {
                timer.cancel();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MentalHelpPage2(widget.idSend))).then((value) => setState(() {}));
              } else {
                _progress1 += 0.2;
              }
            }));
    super.initState();
  }

  double _progress1 = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(254, 246, 238, 10)
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                  TitleHeader("Aprende algo nuevo"),
                  Column(
                    children: <Widget>[
                      H1Label(tips[0]),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(strings[0]),
                            )),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height/2.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/pantallas/como cuidar mi salud mental 1.png'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class MentalHelpPage2 extends StatefulWidget {
  final String idSend;
  MentalHelpPage2(this.idSend);
  @override
  State<MentalHelpPage2> createState() => _MentalHelpPage2State();
}

class _MentalHelpPage2State extends State<MentalHelpPage2> {
late Timer _timer;
  @override
  void initState() {
    _progress1 == 0;
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => setState(() {
              if (_progress1 == 1) {
                timer.cancel();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LearnPage(widget.idSend))).then((value) => setState(() {}));
              } else {
                _progress1 += 0.2;
              }
            }));
    super.initState();
  }

  double _progress1 = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(254, 246, 238, 10),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                  TitleHeader("Aprende algo nuevo"),
                  Column(
                    children: <Widget>[
                      H1Label(tips[1]),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(strings[1]),
                            )),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height/2.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/pantallas/como cuidar mi salud mental 2.png'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}