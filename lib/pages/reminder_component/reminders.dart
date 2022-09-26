// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/pages/reminder_component/create_reminder.dart';
import 'package:mental_health_app/themes/my_colors.dart';

import '../../Components/background_image.dart';
import '../../Components/my_labels.dart';
import '../../models/Reminder.dart';
import '../../security/user_secure_storage.dart';
import '../../utils/endpoints.dart';
import 'modify_reminder.dart';

//void main() => runApp(CalendarPage());

class Reminders extends StatefulWidget {
  final String userId;

  Reminders(this.userId);
  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Reminder> remindersList = [];

  Future<List<dynamic>> fetchRemindersData()async{
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getReminders(widget.userId, name, password);
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
                  TitleHeader("Recordatorios"),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            H1Label("Mis Recordatorios"),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.add_circle, color: waterGreen, size: 30,),
                                iconSize: 20,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateReminder(widget.userId,),
                                    ),
                                  ).then((value) => setState(() {}));
                                },
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: fetchRemindersData(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot){
                            if(snapshot.hasData){
                              remindersList = snapshot.data;
                              return Column(
                                children: [
                                  RemindersListView(
                                    remindersList: remindersList,
                                    popUpMenuOptions: [
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

  Future<Reminder> updateGoal(Reminder reminder) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.updateReminder(widget.userId, username, password, reminder);
  }

  Future<void> deleteReminder(int reminderId) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.deleteReminder(reminderId.toString(), widget.userId, username, password);
  }

  Widget RemindersListView({required List<Reminder> remindersList, required List<Map<String, dynamic>> popUpMenuOptions }) {

    if (remindersList.isEmpty){
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
        itemCount: remindersList.length,
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
                              case "Modificar":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyReminder(
                                      userId: widget.userId,
                                      reminder: remindersList[index],
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                                break;
                              case "Eliminar":
                                await deleteReminder(remindersList[index].id);
                                Fluttertoast.showToast(
                                  msg: 'Recordatorio eliminado: "${remindersList[index].message}"',
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
                          remindersList[index].message,
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
                          DateFormat.yMMMMd("es_US").add_jm().format(DateTime.parse(remindersList[index].reminderDate)),
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
