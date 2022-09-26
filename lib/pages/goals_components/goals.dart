// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/Goal.dart';
import 'package:mental_health_app/pages/goals_components/create_goal.dart';
import 'package:mental_health_app/pages/goals_components/goal_details.dart';
import 'package:mental_health_app/pages/goals_components/modify_goal.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

class Goals extends StatefulWidget {
  final String userId;
  Goals(this.userId);
  @override
  State<Goals> createState() => _ObjectivePage();
}

class _ObjectivePage extends State<Goals> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Goal> goalsList = [];

  Future<List<dynamic>> fetchGoalsData()async{
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getGoals(widget.userId, name, password);
  }

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
            BackgroundImage('assets/fondos/objetivo.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  TitleHeader("Objetivos"),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            H1Label("Objetivos por cumplir"),
                            SizedBox(width: 5,),
                            Container(
                              child: IconButton(
                                icon: Image.asset('assets/icons/add goals.png'),
                                iconSize: 20,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateGoal(widget.userId,),
                                    ),
                                  ).then((value) => setState(() {}));
                                },
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: fetchGoalsData(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot){
                            if(snapshot.hasData){
                              goalsList = snapshot.data;
                              return Column(
                                children: [
                                  GoalsListView(
                                    goalsList: [for (var goal in goalsList) if (goal.status == "Pending") goal],
                                    popUpMenuOptions: [
                                      {
                                        "title": "Completado",
                                        "color": Color(0xFF579C75),
                                        "icon": Icons.check,
                                      },
                                      {
                                        "title": "Modificar",
                                        "color": Color(0xFF829AAF),
                                        "icon": Icons.edit,
                                      },
                                      {
                                        "title": "Eliminar",
                                        "color": Color(0xFFCE4343),
                                        "icon": Icons.delete,
                                      },
                                      {
                                        "title": "Visualizar",
                                        "color": Color(0xFFFC9601),
                                        "icon": Icons.info,
                                      },
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  H1Label("Objetivos Completados"),
                                  GoalsListView(
                                    goalsList: [for (var goal in goalsList) if (goal.status == "Done") goal],
                                    popUpMenuOptions: [
                                      {
                                        "title": "Pendiente",
                                        "color": Color(0xFF579C75),
                                        "icon": Icons.pending,
                                      },
                                      {
                                        "title": "Modificar",
                                        "color": Color(0xFF829AAF),
                                        "icon": Icons.edit,
                                      },
                                      {
                                        "title": "Eliminar",
                                        "color": Color(0xFFCE4343),
                                        "icon": Icons.delete,
                                      },
                                      {
                                        "title": "Visualizar",
                                        "color": Color(0xFFFC9601),
                                        "icon": Icons.info,
                                      },
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  //FinishedObjectivesList(context),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }

  Future<Goal> updateGoal(Goal goal) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.updateGoal(widget.userId, username, password, goal);
  }

  Future<void> deleteGoal(int goalId) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.deleteGoal(goalId.toString(), widget.userId, username, password);
  }

  Widget GoalsListView({required List<Goal> goalsList, required List<Map<String, dynamic>> popUpMenuOptions }) {

    if (goalsList.isEmpty){
      return Center(
        child: Text(
          "Aún no tienes objetivos en esta lista",
          style: TextStyle(fontSize: 18, color: Colors.grey,),
        ),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: goalsList.length,
      itemBuilder: (context, index){
        //solo construye items si es que el length es mayor a 0
        Color goalTypeColor = Colors.white;
        switch (goalsList[index].type) {
          case "Corto Plazo": goalTypeColor = goalsList[index].status == "Pending" ? Color(0xFFB999D2) : Color(0xFFB2AABF); break;
          case "Medio Plazo": goalTypeColor = goalsList[index].status == "Pending" ? Color(0xFF63A8E9) : Color(0xFFB2AABF); break;
          case "Largo Plazo": goalTypeColor = goalsList[index].status == "Pending" ? Color(0xFF8ED1AB) : Color(0xFFB2AABF); break;
        }

        return Container(
          padding: EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                        decoration: BoxDecoration(
                          color: goalTypeColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          goalsList[index].type,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 20,
                      child: PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        tooltip: "Opciones",
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.more_horiz),
                        ),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          for(int i = 0; i < popUpMenuOptions.length; i++)
                            PopupMenuItem<String>(
                              value: popUpMenuOptions[i]["title"],
                              child: ListTile(
                                leading: Icon(
                                  popUpMenuOptions[i]["icon"],
                                  color: popUpMenuOptions[i]["color"],
                                ),
                                title: Text(
                                  popUpMenuOptions[i]["title"],
                                  style: TextStyle(color: popUpMenuOptions[i]["color"]),
                                ),
                              ),
                              onTap: (){
                                //popUpMenuOptions[i]["onSelected"];
                              },
                            ),

                        ],

                        //ACCIONES DISPONIBLES
                        onSelected: (String value) async {
                          switch (value) {
                            case "Completado":
                              goalsList[index].status = "Done";
                              await updateGoal(goalsList[index]);
                              setState(() {});
                              break;
                            case "Pendiente":
                              goalsList[index].status = "Pending";
                              await updateGoal(goalsList[index]);
                              setState(() {});
                              break;
                            case "Modificar":
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyGoal(
                                userId: widget.userId,
                                goal: goalsList[index],
                              ))).then((value) => setState(() {}));
                              break;
                            case "Eliminar":
                              await deleteGoal(goalsList[index].id);
                              Fluttertoast.showToast(
                                msg: 'Eliminando Objetivo "${goalsList[index].message}"',
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              setState(() {});
                              break;
                            case "Visualizar":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoalDetails(userId: widget.userId, goal: goalsList[index]),
                                ),
                              ).then((value) => setState(() {}));
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        goalsList[index].message,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
