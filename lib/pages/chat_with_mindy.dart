// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../components/background_image.dart';
import '../components/bottom_navigation_bar.dart';
import '../themes/my_colors.dart';

class ChatWithMindy extends StatefulWidget {
  final String userId;
  const ChatWithMindy({
    Key? key, required this.userId,

  }) : super(key: key);

  @override
  State<ChatWithMindy> createState() => _ChatWithMindyState();
}

class _ChatWithMindyState extends State<ChatWithMindy> {

  List<dynamic> optionsData = [
    {
      "title": "1. ¿Qué es CBT?",
      "color": Color(0xFFB999D2),
      "content": "La terapia cognitiva conductual (CBT) es un tipo frecuente de terapia del habla (psicoterapia). Trabajas con un asesor de salud mental (psicoterapeuta o terapeuta) de forma estructurada, asistiendo a una cantidad limitada de sesiones. La terapia cognitiva conductual te ayuda a tomar conciencia de pensamientos imprecisos o negativos para que puedas visualizar situaciones exigentes con mayor claridad y responder a ellas de forma más efectiva.",
    },
    {
      "title": "2. ¿Qué es el PHQ-9?",
      "color": Color(0xFF63A8E9),
      "content": "El PHQ-9 es una medida de autoinforme de nueve elementos que evalúan la presencia de síntomas depresivos basados en los criterios del DSM-IV para el episodio depresivo mayor. Refiere a los síntomas experimentados por los pacientes durante las dos semanas previas a la entrevista.",
    },
    {
      "title": "3. ¿Qué es el GAD-7?",
      "color": Color(0xFF8ED1AB),
      "content": "GAD-7 es una prueba sensible autoadministrada para evaluar el trastorno de ansiedad generalizada, que normalmente se usa en entornos ambulatorios y de atención primaria para la remisión a un psiquiatra en espera del resultado.",
    },
    {
      "title": "4. ¿Cómo superar la procrastinación? ",
      "color": Color(0xFFF8CA85),
      "content": "Afortunadamente, hay una serie de cosas diferentes que puede hacer para combatir la procrastinación, por ejemplo: 1.	Haga una lista de tareas pendientes: para ayudarlo a mantenerse al día, considere colocar una fecha de vencimiento al lado de cada elemento.2.	Tome pasos pequeños: divida los elementos de su lista en pasos pequeños y manejables para que sus tareas no parezcan tan abrumadoras.",
    },
    {
      "title": "5. ¿Qué es la inteligencia emocional?",
      "color": Color(0xFFF3A2CD),
      "content": "Es la capacidad de comprender, usar y manejar sus propias emociones de manera positiva para aliviar el estrés, comunicarse de manera efectiva, empatizar con los demás, superar desafíos y calmar conflictos. La inteligencia emocional te ayuda a construir relaciones más sólidas, tener éxito en la escuela y el trabajo, y lograr sus objetivos profesionales y personales.",
    },
  ];
  var selectedOption;
  late List<Widget> messages;

  void newQuestion(){
    messages.add(
      Message(
        senderName: "Mindy",
        senderAvatar: "assets/bot_emocionado.png",
        content: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Elige una de las opciones:"),
              for(var option in optionsData)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: option["color"],
                  ),
                  child: Text(
                    option["title"],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  onPressed: (){
                    messages.add(
                        Message(
                          content: Text("Elijo la opción: ${option["title"][0]}"),
                        )
                    );
                    messages.add(
                      Message(
                        senderName: "Mindy",
                        senderAvatar: "assets/bot_emocionado.png",
                        content: Text(option["content"]),
                      ),
                    );
                    newQuestion();
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    messages = [
      Message(
        senderName: "Mindy",
        senderAvatar: "assets/bot_emocionado.png",
        content: Text(
          "¡Hola, soy Mindy! Te ayudaré a complementar tus dudas sobre conceptos de la salud mental.",
        ),
      ),
    ];
    newQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage("assets/fondos/chatbot.png"),
            Column(
              children: [
                Container(
                  color: intensePurple,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded, size: 30,),
                        color: Color(0xFFC5BECE),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/bot_emocionado.png", width: 45,),
                      ),
                      Column(
                        children: [
                          Text(
                            "Mindy",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            "Disponible",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.circle, color: Colors.greenAccent, size: 15,),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 630,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: messages,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        idSend: widget.userId,
        isTheSameChatMindy: true,
        mindyColorIcon: false,
      ),
    );
  }

  Widget Message({
    String? senderName,
    String? senderAvatar,
    required Widget content,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: senderName == null ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            senderAvatar == null ? SizedBox() : Container(
              alignment: Alignment.topCenter,
              child: Image.asset(senderAvatar, width: 60,),
            ),
            SizedBox(width: 15,),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  senderName == null ? SizedBox() : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      senderName,
                      style: TextStyle(
                        color: Color(0xFF7C7C88),
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(height: 5,),
                  Container(
                    width: senderName == null ? 140 : 270,
                    decoration: BoxDecoration(
                      color: senderName == null ? softPink : lightWaterGreen,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: content,
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
    );
  }
}


