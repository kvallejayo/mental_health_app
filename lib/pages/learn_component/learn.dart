// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/pages/learn_component/knowledgeDetails.dart';
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

  List<Map<String, dynamic>> psychologyConcepts = [
    {
      "title": "¿Qué es CBT?",
      "cardImg": "assets/learn/que es cbt.png",
      "concept": "La terapia cognitiva conductual (CBT) es un tipo frecuente de terapia del habla (psicoterapia). Trabajas con un asesor de salud mental (psicoterapeuta o terapeuta) de forma estructurada, asistiendo a una cantidad limitada de sesiones. La terapia cognitiva conductual te ayuda a tomar conciencia de pensamientos imprecisos o negativos para que puedas visualizar situaciones exigentes con mayor claridad y responder a ellas de forma más efectiva.",
      "moreInfo": "El CBT puede ser una herramienta muy útil, ya sea sola o en combinación con otras terapias, para tratar los trastornos de salud mental, como la depresión, el trastorno de estrés postraumático (TEPT) o un trastorno de la alimentación. Sin embargo, no todas las personas que se benefician de la terapia cognitiva conductual tienen una enfermedad mental. El CBT puede ser una herramienta eficaz para ayudar a cualquier persona a aprender cómo manejar mejor las situaciones estresantes de la vida.",
      "video": "",
      "image": "",
    },
    {
      "title": "¿Por qué es importante el test GAD-7?",
      "cardImg": "assets/learn/gad.png",
      "concept": "GAD-7 es una prueba sensible autoadministrada para evaluar el trastorno de ansiedad generalizada, que normalmente se usa en entornos ambulatorios y de atención primaria para la remisión a un psiquiatra en espera del resultado.",
      "moreInfo": "Los datos normativos permiten a los usuarios del GAD-7 discernir si la puntuación de ansiedad de una persona es normal o leve, moderada o gravemente elevada. Sin embargo, no se puede usar como reemplazo de la evaluación clínica y se debe usar una evaluación adicional para confirmar un diagnóstico de TAG.",
      "video": "",
      "image": "assets/learn/gad dibujo.png",
    },
    {
      "title": "¿Qué mide el test PHQ-9?",
      "cardImg": "assets/learn/phq.png",
      "concept": "GAD-7 es una prueba sensible autoadministrada para evaluar el trastorno de ansiedad generalizada, que normalmente se usa en entornos ambulatorios y de atención primaria para la remisión a un psiquiatra en espera del resultado. ",
      "moreInfo": "Los datos normativos permiten a los usuarios del GAD-7 discernir si la puntuación de ansiedad de una persona es normal o leve, moderada o gravemente elevada. Sin embargo, no se puede usar como reemplazo de la evaluación clínica y se debe usar una evaluación adicional para confirmar un diagnóstico de TAG.",
      "video": "",
      "image": "",
    },
  ];

  List<Map<String, dynamic>> knowledgesInfo = [
    {
      "title": "¿Cómo superar la procrastinación?",
      "cardImg": "assets/learn/como superar.png",
      "concept": "Afortunadamente, hay una serie de cosas diferentes que puede hacer para combatir la procrastinación, por ejemplo: 1.	Haga una lista de tareas pendientes: para ayudarlo a mantenerse al día, considere colocar una fecha de vencimiento al lado de cada elemento. 2.	Tome pasos pequeños: divida los elementos de su lista en pasos pequeños y manejables para que sus tareas no parezcan tan abrumadoras. 3.	Reconozca las señales de advertencia: preste atención a cualquier pensamiento de procrastinación y haga todo lo posible para resistir la tentación. Si comienza a pensar en posponer las cosas, oblíguese a dedicar unos minutos a trabajar en su tarea. 4.	Elimine las distracciones: pregúntese qué atrae más su atención, ya sea Instagram, las actualizaciones de Facebook o las noticias locales, y apague esas fuentes de distracción. 5.	Date una palmadita en la espalda: cuando termines un elemento de tu lista de tareas pendientes a tiempo, felicítate y recompénsate con algo que te resulte divertido.",
      "moreInfo": "",
      "video": "https://www.youtube.com/watch?v=irp5ghCVNAM",
      "image": "",
    },
    {
      "title": "¿Qué es el registro de pensamientos (Reestructuración cognitiva)?",
      "cardImg": "assets/learn/registro de pensamientos.png",
      "concept": "La Reestructuración Cognitiva (RC) es una técnica básica de la terapia cognitivo-conductual. La técnica consiste en la discusión de los pensamientos automáticos negativos que se producen en situaciones que provocan ansiedad o cualquier otro tipo de perturbación emocional (por ejemplo, “Creen que soy aburrido”) y su sustitución por creencias o pensamientos más racionales (como “No puedo leer la mente de otras personas, probablemente están cansados ahora”). A medida que los pensamientos son enfrentados y puestos en duda, su capacidad para provocar estrés o ansiedad se debilita.",
      "moreInfo": "",
      "video": "https://www.youtube.com/watch?v=2LRlXXg52b0",
      "image": "",
    },
    {
      "title": "La procrastinación",
      "cardImg": "assets/learn/procrastinacion.png",
      "concept": 'Según Joseph Ferrari, profesor de psicología en la Universidad DePaul en Chicago y autor de "Still Procrastinating: The No Regret Guide to Getting It Done", alrededor del 20 % de los adultos estadounidenses son procrastinadores crónicos. Los investigadores sugieren que la procrastinación puede ser particularmente pronunciada entre los estudiantes. Un metaanálisis de 2007 publicado en el Psychological Bulletin encontró que entre el 80 % y el 95 % de los estudiantes universitarios posponen las cosas con regularidad, particularmente cuando se trata de completar tareas y cursos.',
      "moreInfo": "A menudo nos encontramos con una serie de excusas o racionalizaciones para justificar nuestro comportamiento. Según los investigadores, hay 15 razones clave por las que las personas dicen que posponen las cosas: 1.	Sin saber lo que hay que hacer. 2.	No saber cómo hacer algo. 3.	no querer hacer algo. 4.	Sin importar si se hace o no. 5.	No me importa cuando algo se hace. 6.	No tener ganas de hacerlo. 7.	Tener la costumbre de esperar hasta el último momento. 8.	Creer que se trabaja mejor bajo presión. 9.	Pensando que puedes terminarlo en el último minuto. 10.	Falta de iniciativa para empezar. 11.	Olvidando. 12.	Culpar a la enfermedad o a la mala salud. 13.	Esperando el momento adecuado. 14.	Necesidad de tiempo para pensar en la tarea. 15.	Retrasar una tarea a favor de trabajar en otra",
      "video": "",
      "image": "",
    },
    {
      "title": "¿Qué es la inteligencia emocional?",
      "cardImg": "assets/learn/inteligencia emocional.png",
      "concept": "La inteligencia emocional (también conocida como cociente emocional o EQ) es la capacidad de comprender, usar y manejar sus propias emociones de manera positiva para aliviar el estrés, comunicarse de manera efectiva, empatizar con los demás, superar desafíos y calmar conflictos. La inteligencia emocional te ayuda a construir relaciones más sólidas, tener éxito en la escuela y el trabajo, y lograr sus objetivos profesionales y personales. También puede ayudarlo a conectarse con sus sentimientos, convertir la intención en acción y tomar decisiones informadas sobre lo que más le importa.",
      "moreInfo": "",
      "video": "https://www.youtube.com/watch?v=vkhmTQ1PFbo",
      "image": "",
    },
    {
      "title": "¿Qué es trastorno de hiperactividad con déficit de atención?",
      "cardImg": "assets/learn/deficit atencion.png",
      "concept": "Es un problema causado por la presencia de una o más de estas condiciones: no ser capaz de concentrarse, ser hiperactivo o no ser capaz de controlar el comportamiento. El trastorno de hiperactividad con déficit de atención (THDA) a menudo comienza en la niñez. Sin embargo, puede continuar en la adultez. El THDA se diagnostica más a menudo en niños que en niñas.",
      "moreInfo": "No hay claridad sobre la causa del THDA. Puede estar vinculado a los genes y a factores en el hogar o sociales. Los expertos han encontrado que los niños con THDA son diferentes que aquellos niños sin este trastorno. La química cerebral también es diferente.",
      "video": "https://www.youtube.com/watch?v=mkdbzEg0VYE",
      "image": "",
    },
    {
      "title": "¿Qué es Trastorno obsesivo compulsivo (TOC)?",
      "cardImg": "assets/learn/toc.png",
      "concept": "El trastorno obsesivo compulsivo (TOC) se caracteriza por un patrón de pensamientos y miedos no deseados (obsesiones) que provocan comportamientos repetitivos (compulsiones). Estas obsesiones y compulsiones interfieren en las actividades diarias y causan un gran sufrimiento emocional.",
      "moreInfo": "",
      "video": "https://www.youtube.com/watch?v=s180DqE-wQU",
      "image": "",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

                      for(var psychologyConcept in psychologyConcepts)
                        GestureDetector(
                          child: Image.asset(psychologyConcept["cardImg"], width: 350,),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => KnowledgeDetails(
                                  userId: widget.userId,
                                  knowledgeInfo: psychologyConcept,
                                ),
                              ),
                            );
                          },
                        ),

                      H1Label("Nuevos conocimientos"),

                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          for (var knowledgeInfo in knowledgesInfo)
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
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
                                  child: Image.asset(knowledgeInfo["cardImg"]),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => KnowledgeDetails(
                                      userId: widget.userId,
                                      knowledgeInfo: knowledgeInfo,
                                    ),
                                  ),
                                );
                              },
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
      bottomNavigationBar: BottomNavigation(
        isTheSameLearn: true,
        learnColorIcon: false,
        idSend: widget.userId,
      ),
    );
  }
}
