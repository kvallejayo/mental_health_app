// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/my_labels.dart';
//import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../components/bottom_navigation_bar.dart';

class RespirationExerciseDetails extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> respirationExercise;
  const RespirationExerciseDetails({Key? key, required this.userId, required this.respirationExercise}) : super(key: key);

  @override
  State<RespirationExerciseDetails> createState() => _RespirationExerciseDetailsState();
}

class _RespirationExerciseDetailsState extends State<RespirationExerciseDetails> {
  //late YoutubePlayerController ytController;

  @override
  void initState() {
    /*
    ytController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: true,
        loop: false,
      ),
    )..onInit = (){
      ytController.loadVideo(widget.respirationExercise["video"]);
    };

     */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 15;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage("assets/fondos/ejercicios respiracion.png"),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Ejercicios de Respiración"),
                  Container(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.respirationExercise["title"],
                            style: TextStyle(
                              color: Color(0xFF9296BB),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Duración estimada: ${widget.respirationExercise["duration"]}",
                            style: TextStyle(
                              color: Color(0xFF9B99A6),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.respirationExercise["description"],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Image.asset(widget.respirationExercise["illustration"], width: 130,),
                          ],
                        ),
                        SizedBox(height: 15,),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recomendaciones:",
                            style: TextStyle(
                              color: Color(0xFF9296BB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        for(var recommendation in widget.respirationExercise["recommendations"])
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              recommendation,
                              style: TextStyle(
                                fontSize: fontSize,
                              ),
                            ),
                          ),

                        SizedBox(height: 15,),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Video:",
                            style: TextStyle(
                              color: Color(0xFF9296BB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /*

                        Container(
                          width: 400,
                          child: YoutubePlayerControllerProvider(
                            controller: ytController,
                            child: YoutubePlayer(
                              controller: ytController,
                            ),
                          ),
                        ),

                         */
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }
}
