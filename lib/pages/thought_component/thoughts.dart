// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/pages/thought_component/create_thought.dart';
import 'package:mental_health_app/pages/thought_component/modify_thought.dart';
import 'package:mental_health_app/pages/thought_component/thought_details.dart';

import '../../Components/background_image.dart';
import '../../Components/bottom_navigation_bar.dart';
import '../../Components/my_labels.dart';
import '../../models/Thoughts.dart';
import '../../security/user_secure_storage.dart';
import '../../themes/my_colors.dart';
import '../../utils/endpoints.dart';

class Thoughts extends StatefulWidget {
  final String userId;
  const Thoughts({Key? key, required this.userId}) : super(key: key);

  @override
  State<Thoughts> createState() => _ThoughtsState();
}

class _ThoughtsState extends State<Thoughts> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Thought> thoughtsList = [];

  Future<List<dynamic>> fetchThoughtsData()async{
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getThoughts(widget.userId, name, password);
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
                  TitleHeader("Pensamientos"),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            H1Label("Mis Pensamientos"),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.add_circle, color: waterGreen, size: 30,),
                                iconSize: 20,
                                onPressed: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateThought(userId: widget.userId),
                                    ),
                                  ).then((value) => setState(() {}));
                                },
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: fetchThoughtsData(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot){
                            if(snapshot.hasData){
                              thoughtsList = snapshot.data;
                              return Column(
                                children: [
                                  ThoughtsListView(
                                    thoughtsList: thoughtsList,
                                    popUpMenuOptions: [
                                      {
                                        "title": "Visualizar",
                                        "color": Colors.orange,
                                        "icon": Icons.info,
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

  Future<Thought> updateThought(Thought thought) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.updateThought(widget.userId, username, password, thought);
  }

  Future<void> deleteThought(int thoughtId) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.deleteThought(thoughtId.toString(), widget.userId, username, password);
  }

  Widget ThoughtsListView({required List<Thought> thoughtsList, required List<Map<String, dynamic>> popUpMenuOptions }) {

    if (thoughtsList.isEmpty){
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
        itemCount: thoughtsList.length,
        itemBuilder: (context, index){
          //solo construye items si es que el length es mayor a 0

          return Container(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 20, height: 20,
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
                              ),
                          ],

                          //ACCIONES DISPONIBLES
                          onSelected: (String value) async {
                            switch (value) {
                              case "Visualizar":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ThoughtDetails(
                                      userId: widget.userId,
                                      thought: thoughtsList[index],
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                                break;
                              case "Modificar":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyThought(
                                      userId: widget.userId,
                                      thought: thoughtsList[index],
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                                break;
                              case "Eliminar":
                                await deleteThought(thoughtsList[index].id);
                                Fluttertoast.showToast(
                                  msg: 'Pensamiento eliminado: "${thoughtsList[index].situation}"',
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                setState(() {});
                                break;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          thoughtsList[index].situation ,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          DateFormat.yMMMMd("es_US").add_jm().format(DateTime.parse(thoughtsList[index].createdAt)),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(height: 10,),
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
