// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_calendar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/components/screen_form.dart';

import 'package:mental_health_app/models/SleepRecord.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';
import '../home.dart';
import 'Mod and create dreams/create_sleep_record_page.dart';
import 'Mod and create dreams/modify_sleep_record_page.dart';

class SleepRecordsPage extends StatefulWidget {
  final String idSend;

  SleepRecordsPage(this.idSend);
  @override
  State<SleepRecordsPage> createState() => _SleepRecordsPageState();
}

class _SleepRecordsPageState extends State<SleepRecordsPage> {

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future<List<SleepRecord>> fetchSleepRecordsData() async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getSleepsRecords(widget.idSend, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              BackgroundImage('assets/fondos/sueño.png'),
              Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height,
                child: Image.asset("assets/graficas/vista_dibujo_sueño.png"),
              ),
              Column(
                children: [
                  TitleHeader("Registro de sueño"),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            H1Label("Historial de sueño"),
                            IconButton(
                              icon: Image.asset('assets/icons/add.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateSleepRecordPage(widget.idSend,),),
                                ).then((value) => setState(() {}));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        SingleChildScrollView(
                          child: FutureBuilder(
                            future: fetchSleepRecordsData(),
                            builder: (context, AsyncSnapshot<List<SleepRecord>> snapshot) {
                              if (!snapshot.hasData){
                                return CircularProgressIndicator();
                              }
                              List<SleepRecord>? sleepRecordsList = snapshot.data;
                              if(sleepRecordsList!.isEmpty){
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
                                itemCount: sleepRecordsList.length,
                                itemBuilder: (context, index){
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
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
                                                  "Dormiste ${sleepRecordsList[index].duration.toString()} horas",
                                                  style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                tooltip: "Opciones",
                                                onSelected: (String value) async {
                                                  if (value == "Eliminar") {
                                                    final name = await UserSecureStorage.getUsername() ?? '';
                                                    final password = await UserSecureStorage.getPassword() ?? '';
                                                    await dataBaseHelper.deleteSleepRecord(
                                                      widget.idSend,
                                                      name,
                                                      password,
                                                      sleepRecordsList[index].id.toString(),
                                                    );
                                                    setState(() {});

                                                  } else if (value == "Modificar") {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ModifySleepRecordPage(
                                                          widget.idSend,
                                                          sleepRecordsList[index],
                                                        ),
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
                                            ],
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                sleepRecordsList[index].message.toString(),
                                                style: TextStyle(fontSize: 16),
                                              )),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              DateFormat.yMMMMd("es_US").format(DateTime.parse(sleepRecordsList[index].startDate)),
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        idSend: widget.idSend,
      ),
    );
  }
}
