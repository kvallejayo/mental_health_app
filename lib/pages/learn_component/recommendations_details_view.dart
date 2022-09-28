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
  RecommendationsDetailsView(this.idSend);
  @override
  State<RecommendationsDetailsView> createState() => _RecommendationsDetailsViewState();
}

class _RecommendationsDetailsViewState extends State<RecommendationsDetailsView> {

  List<Map<String, dynamic>> recommendations = [
    {
      "title": "¿Cómo cuidar mi salud mental?",
      "content": "1. Reconoce tus emociones. 2. Piensa en lo que puedes hacer para distraerte. 3. Mantén el contacto con tus seres queridos. 4. Fíjate en las cosas buenas. 5. Sé amable contigo y con los demás. 6. No descuides tu salud. 7. Conoce y comparte experiencias con otros adolescentes y jóvenes. 8. Si te gusta dibujar y pintar, ¡comparte tu talento!",
      "image": "assets/learn/como cuidar mi salud mental 1.png",
    },
    {
      "title": "¿Cómo la salud mental puede afectar en mis estudios?",
      "content": "Los problemas de salud mental tienen un gran impacto en el rendimiento académico, aumentan el riesgo de abandono de las carreras y actúan insidiosamente en la percepción que las personas tienen de sí mismas y en sus relaciones sociales. Además, pueden ser fuertes predictores de un menor rendimiento ocupacional y nivel de empleabilidad en el futuro. Por ello, recomendamos acudir a un profesional si sientes que no lo puedes manejar y necesitas ayuda.",
      "image": "assets/learn/salud estudios.png",
    },
    {
      "title": "9 consejos para mejorar tu productividad personal",
      "content": "1.	Iniciar con las tareas más difíciles. 2.	Delegar responsabilidades. 3.	Usar una pizarra. 4.	Tomar un descanso. 5.	Ahorrar tiempo. 6.	Clasificar tareas. 7.	Mantener el orden. 8.	Aprender a decir “No”. 9.	Iniciar el día temprano.",
      "image": "assets/learn/consejo productividad.png",
    },
  ];

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
            recommendationIndex += 1;
            if (recommendationIndex >= recommendations.length){
              recommendationIndex = 0;
              _progress1 = 0;
            }
          } else {
            _progress1 += 0.2;
          }
          print(_progress1);
        });
      },
    );
    super.initState();
  }

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
        child: Stack(
          children: [
            Container(
              color: Color.fromRGBO(254, 246, 238, 10),
            ),
            StoryContent(recommendation: recommendations[recommendationIndex],),
          ],
        ),
      ),
    );
  }


  Widget StoryContent({required Map<String,dynamic> recommendation}) {
    return Container(
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
            recommendation["title"],
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
                child: Text(recommendation["content"]),
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
                image: AssetImage(recommendation["image"]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryView extends StatefulWidget {
  final Map<String,dynamic> recommendation;

  StoryView({required this.recommendation});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {

  late Timer _timer;
  double _progress1 = 0;

  @override
  void initState() {
    _progress1 == 0;
    _timer = Timer.periodic(
      Duration(seconds: 1),
          (timer) {
        setState(() {
          if (_progress1 == 1) {
            timer.cancel();

            //QUE HACER CUANDO SE VENCE EL PLAZO

            /*

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryView(widget.idSend),
              ),
            ).then((value) => setState(() {}));

             */


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
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}