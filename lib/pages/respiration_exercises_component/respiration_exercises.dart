// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/pages/respiration_exercises_component/respiration_exercise_details.dart';

class RespirationExercises extends StatefulWidget {
  final String userId;

  RespirationExercises(this.userId);

  @override
  State<RespirationExercises> createState() => _RespirationExercisesState();
}

class _RespirationExercisesState extends State<RespirationExercises> {
  List<dynamic> respirationExercices = [
    {
      "title": "Técnica 4 - 7 - 8",
      "image": "assets/respiration/tecnica478.png",
      "description": "Inhala el aire a través de la nariz, cuenta hasta 4. Aguanta la respiración durante 7 segundos y exhala completamente el aire de sus pulmones durante 8 segundos.(Realizar 4 repeticiones)",
      "duration": "1 minuto y 20 segundos",
      "illustration": "assets/respiration/4-7-8.png",
      "recommendations": [
        "Practicarlo en un lugar tranquilo y silencioso",
        "Colocar tu lengua en el paladar justo detrás de los dientes superiores.",
        "Realizar un sonido profundo de la respiración con el fin de escucharlo mientras realizas el ejercicio.",
      ],
      "video": "https://www.youtube.com/watch?v=a4LxzATy-4Y",
      "videoButtonImg": "assets/videoBotones/478.png",
    },
    {
      "title": "Respiración  abdominaL",
      "image": "assets/respiration/respiración_abdominal.png",
      "description": "Coloca una mano en tu pecho y otra en el abdomen, inhala profundamente por la nariz, asegurandote que el diafragma baja (hinchando el abdomen)  Procura que sea el abdomen se mueva, no el pecho. (6 a 10 respiraciones lentas por minuto.)",
      "duration": "2 minutos y 30 segundos",
      "illustration": "assets/respiration/abdominal.png",
      "recommendations": [
        "Dirigir mensajes positivos hacia ti durante el procedimiento",
        "No respirar exageradamente. Mantener el cuerpo relajado.",
        "Sentarse derecho y colocar las manos sobre el vientre.",
      ],
      "video": "https://www.youtube.com/watch?v=COvvQMueCqY",
      "videoButtonImg": "assets/videoBotones/respiracion_abdominal.png",
    },
    {
      "title": "Respiración  cuadrada",
      "image": "assets/respiration/respiracion_cuadrada.png",
      "description": "Simplemente evita inhalar o exhalar durante 4 segundos. Empieza a exhalar lentamente durante 4 segundos. Repite los pasos 1 a 3 al menos tres veces.(Repetir los tres pasos durante 4minutos, o hasta que vuelva la calma)",
      "duration": "4 minutos",
      "illustration": "assets/respiration/cuadrado.png",
      "recommendations": [
        "Practicarlo en un lugar tranquilo y silencioso."
        "Mantener el cuerpo relajado."
        "Dirigir mensajes positivos hacia ti durante el procedimiento."
      ],
      "video": "https://www.youtube.com/watch?v=v0oXAnyTyWo",
      "videoButtonImg": "assets/videoBotones/respiracion_cuadrada.png",
    },
    {
      "title": "Relajación muscular progresiva ",
      "image": "assets/respiration/relajacion_muscular.png",
      "description": "Manteniendo respiraciones profundas y lentas, empezamos inhalando por la nariz contando hasta cinco mientras tensamos nuestros pies, y exhalamos por la boca contando hasta cinco relajándolos. Prueba a repetirlo para diferentes zonas de tu cuerpo: rodillas, muslos, glúteos, pecho, brazos, manos y dedos, cuello y mandíbula y ojos.",
      "duration": "8 minutos",
      "illustration": "assets/respiration/muscular.png",
      "recommendations": [
        "Practicarlo en un lugar tranquilo y silencioso.",
        "Dirigir mensajes positivos hacia ti durante el procedimiento.",
        "Imagina una escena agradable y tranquila.",
      ],
      "video": "https://www.youtube.com/watch?v=f9CnqxwMG40",
      "videoButtonImg": "assets/videoBotones/respiracion_muscular_progresiva.png",
    },
    {
      "title": "Respiración  nasal alterna",
      "image": "assets/respiration/respiración_nasal_alterna.png",
      "description": "Coloca tu mano como el dibujo poniendo el  pulgar derecho en la fosa nasal derecha e inhala profundamente a través de la fosa nasal izquierda. Al llegar al pico de la inhalación, tapa la fosa nasal izquierda con el anular y el meñique, libera la derecha, luego exhala a través de la fosa nasal derecha. Continúa este patrón, inhalando por la fosa nasal derecha, luego cerrandola con el pulgar derecho y exhalando a través de la fosa nasal izquierda de cuatro a ocho veces.",
      "duration": "1 minuto y 20 segundos",
      "illustration": "assets/respiration/nasal.png",
      "recommendations": [
        "Practicarlo en un lugar tranquilo y silencioso.",
        "Mantener en una postura cómoda.",
        "Dirigir mensajes positivos hacia ti durante el procedimiento.",
      ],
      "video": "https://www.youtube.com/watch?v=9nHT14vrcH4",
      "videoButtonImg": "assets/videoBotones/respiracion_nasal_alterna.png",
    },
    {
      "title": "Respiración Energizante",
      "image": "assets/respiration/respiracion_energizante.png",
      "description": "Se trata de realizar una inhalación larga y lenta, expandiendo el diafragma, para a continuación exhalar de forma rápida contrayendo el diafragma. Todo por la nariz. Inhalar lento y profundo y exhalar rápido y fuerte.(10 repeticiones)",
      "duration": "2 minutos",
      "illustration": "assets/respiration/energizante.png",
      "recommendations": [
        "Busca una posición cómoda.",
        "Colocar tu lengua en el paladar justo detrás de los dientes superiores.",
        "Realizar un sonido profundo de la respiración con el fin de escucharlo mientras realizas el ejercicio.",
      ],
      "video": "https://www.youtube.com/watch?v=wJnCZI49Xp0",
      "videoButtonImg": "assets/videoBotones/respiracion_energizante.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/ejercicios respiracion.png'),
            Column(
              children: [
                TitleHeader("Ejercicios de respiración"),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: respirationExercices.length,
                    itemBuilder: (context, index){
                      return GridTile(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10,),
                            child: Center(
                              child: Image.asset(respirationExercices[index]["image"]),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RespirationExerciseDetails(
                                  userId: widget.userId,
                                  respirationExercise: respirationExercices[index],
                              ),),
                            );
                          },
                        ),
                        footer: Container(
                          padding: EdgeInsets.only(top: 100),
                          alignment: Alignment.center,
                          child: Text(
                            respirationExercices[index]["title"],
                            style: TextStyle(
                              color: Color(0xFF73706C),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }
}
