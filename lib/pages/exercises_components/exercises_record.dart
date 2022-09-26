// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/Exercise.dart';
import '../../security/user_secure_storage.dart';
import '../../utils/endpoints.dart';
import 'Mod and Create Exercises/record_exercises_create.dart';
import 'Mod and Create Exercises/record_exercises_mod.dart';

class ExercisesRecordPage extends StatefulWidget {
  final String idSend;

  ExercisesRecordPage(this.idSend);
  @override
  State<ExercisesRecordPage> createState() => _ExercisesRecordPageState();
}

class _ExercisesRecordPageState extends State<ExercisesRecordPage> {

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Exercise> exercisesList = <Exercise>[];

  Future<List<Exercise>> fetchExerciseRecordsData() async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getExercises(widget.idSend, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/ejercicios fisicos.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Ejercicios físicos"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            H1Label("Historial de ejercicios"),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RecordExercisesCreate(widget.idSend,),),
                                ).then((value) => setState(() {}));
                              },
                              icon: Image.asset('assets/icons/add.png'),
                            ),
                          ],
                        ),
                        FutureBuilder(
                            future: fetchExerciseRecordsData(),
                            builder: (context, AsyncSnapshot<List<Exercise>> snapshot) {
                              if(!snapshot.hasData){
                                return Center(child: CircularProgressIndicator(),);
                              }
                              exercisesList = snapshot.data!;
                              if(exercisesList.isEmpty){
                                return Center(
                                  child: Text(
                                    "No hay elementos en la lista",
                                    style: TextStyle(fontSize: 20, color: Colors.grey),
                                  ),
                                );
                              }
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: exercisesList.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: ExerciseListTile(exercisesList[index]),
                                  );
                                },
                              );
                            }
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
      bottomNavigationBar: BottomNavigation(idSend: widget.idSend),
    );
  }
  Widget ExerciseListTile(Exercise exercise){
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  ("${exercise.duration} minutos"),
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                child: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  tooltip: "Opciones",
                  onSelected: (String value) async {
                    if (value == "Eliminar") {
                      final name = await UserSecureStorage.getUsername() ?? '';
                      final password = await UserSecureStorage.getPassword() ?? '';
                      await dataBaseHelper.deleteExercise(
                        widget.idSend,
                        name,
                        password,
                        exercise.id.toString(),
                      );
                      setState(() {});

                    } else if (value == "Modificar") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordExercisesMod(idSend: widget.idSend, exercise: exercise),
                        ),
                      ).then((value) => setState(() {}));
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Modificar",
                      child: ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Color.fromRGBO(139, 168, 194, 10),
                        ),
                        title: Text(
                          "Modificar",
                          style: TextStyle(
                            color: Color.fromRGBO(139, 168, 194, 10),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Eliminar",
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                exercise.message,
                style: TextStyle(fontSize: 16),
              )),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat.yMMMMd("es_US").format(DateTime.parse(exercise.startDate)),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}