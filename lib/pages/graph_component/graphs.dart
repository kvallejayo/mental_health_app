// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/pages/graph_component/graph_moods.dart';
import 'package:mental_health_app/pages/home.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

import 'chart_data.dart';
import 'graph_dreams.dart';
import 'graph_exercises.dart';

class GraphPage extends StatefulWidget {
  final String idSend;

  GraphPage(this.idSend);
  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<String> dayOftheWeek = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado"
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
            BackgroundImage('assets/fondos/home graficas.png'),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Mis Estadísticas",
                          style: TextStyle(
                              color: Color.fromRGBO(98, 89, 134, 10),
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15,),
                    Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                              child: CircularPercentIndicator(
                                animation: true,
                                radius: 100,
                                backgroundColor: Color.fromRGBO(165, 109, 139, 10),
                                progressColor: Color.fromRGBO(236, 181, 210, 10),
                                startAngle: 80.0,
                                percent: .6,
                                lineWidth: 20,
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  "¡Hoy es un nuevo día para cumplir tus metas!",
                                  style: TextStyle(
                                    color: Color(0XFF725062),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 6,),
                                Text(
                                  "Te recomendamos dar un vistazo a tus gráficas para un mejor seguimiento",
                                  style: TextStyle(
                                    color: Color.fromRGBO(141, 109, 126, 0.62),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Horas de sueño",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  child: Image.asset(
                                    'assets/graficas/sueño.png',
                                    width: 165,
                                  ),
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GraphDreamsPage(widget.idSend),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Mis Emociones",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  child: Image.asset(
                                    'assets/graficas/emociones.png',
                                    width: 165,
                                  ),
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GraphMoodsPage(widget.idSend),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),

                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Tiempo de Ejercicios",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            child: Image.asset(
                              'assets/graficas/ejercicio.png',
                              width: MediaQuery.of(context).size.width,
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GraphExercisesPage(widget.idSend),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameGraph: true,
        graphColorIcon: false,
        idSend: widget.idSend,
      ),
    );
  }
}