// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../security/user_secure_storage.dart';
import '../themes/my_colors.dart';
import 'dart:math' as math;

import '../utils/endpoints.dart';

class TitleHeader extends StatelessWidget {
  String title;
  TitleHeader(
    this.title,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF615987),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),

      ],
    );
  }
}

class H1Label extends StatelessWidget {
  String h1;
  H1Label(
    this.h1,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          h1,
          style: TextStyle(
              color: Color.fromRGBO(147, 150, 186, 10),
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class InputLabel extends StatelessWidget {
  InputLabel(this.text, TextEditingController dateController);
  TextEditingController dateController = TextEditingController();
  String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 70,
        //color: Colors.white,
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 242, 250, 10),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: dateController,
                dragStartBehavior: DragStartBehavior.start,
                decoration: InputDecoration.collapsed(hintText: text),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagsLabelObjective extends StatelessWidget {
  var duration = ["Corto Plazo", "Mediano Plazo", "Largo Plazo"];
  List<Color> colors = [
    Color.fromRGBO(186, 152, 209, 10),
    Color.fromRGBO(106, 168, 231, 10),
    Color.fromRGBO(156, 212, 176, 10)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < duration.length; i++)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  duration[i],
                  style: TextStyle(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class TagsCategories extends StatelessWidget {
  var duration = ["Estilo de vida", "Salud", "Alimentación"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < duration.length; i++)
              Container(
                width: 110,
                height: 35,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  duration[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ButtomLabel extends StatelessWidget {
  ButtomLabel(this.text);
  String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 300,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: waterGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          onPressed: () {},
          child: Text(text,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(246, 239, 227, 10),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]),
      child: Text(
          "Hoy me sentí muy feliz porque pude dar una buena exposición parcial para mi trabajo de la universidad."),
    );
  }
}

class ContainerLabelExercises extends StatefulWidget {
  final String idSend;

  ContainerLabelExercises(this.idSend);

  @override
  State<ContainerLabelExercises> createState() =>
      _ContainerLabelExercisesState();
}

class _ContainerLabelExercisesState extends State<ContainerLabelExercises> {
  List<String> dayOftheWeek = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado"
  ];
  DataBaseHelper httpHelper = new DataBaseHelper();
  List<dynamic> exercisesList = [];
  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    final token = await UserSecureStorage.getToken() ?? '';
    final userId = await UserSecureStorage.getUserId() ?? '';

    exercisesList =
        await httpHelper.getExercises(widget.idSend, name, password);

    print("sleepList: " + exercisesList.toString());
    print("first: " + exercisesList[0].toString());
    print("startDate first: " + exercisesList[0]["startDate"].toString());
    print("size: " + exercisesList.length.toString());
    //convert string to int
    //lista vacia  mensaje de error

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < exercisesList.length; i++)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height / 5.5,
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              padding: EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 239, 227, 10),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Duración: " +
                                exercisesList[i]["duration"].toString() +
                                " horas",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: PopupMenuButton<String>(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                tooltip: "Opciones",
                                /*onSelected: (String value) {
                                    if (value == "Eliminar") {
                                      dataBaseHelper.deleteReminder(
                                          remindersList[i]['id']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReminderPage(widget.idSend)));
                                    }
                                  },*/
                                //padding: EdgeInsets.zero,
                                onSelected: (String value) async {
                                  if (value == "Eliminar") {
                                    final name =
                                        await UserSecureStorage.getUsername() ??
                                            '';
                                    final password =
                                        await UserSecureStorage.getPassword() ??
                                            '';
                                    await httpHelper.deleteExercise(
                                        widget.idSend,
                                        name,
                                        password,
                                        exercisesList[i]['id']);
                                  }
                                },
                                icon: Icon(Icons.more_horiz),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: "Modificar",
                                        child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text("Modificar"),
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: "Eliminar",
                                        child: ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text("Eliminar"),
                                        ),
                                      )
                                    ]))
                      ],
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fecha: " + exercisesList[i]["startDate"].toString(),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // Mayuscula la primera letra  y despues todo minusculas
                          "Día de la semana: " +
                              exercisesList[i]["dayOfTheWeek"]
                                  .toString()
                                  .toLowerCase(),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ejercicio a realizar: " +
                              exercisesList[i]["message"].toString(),
                        )),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ContainerLabelDreams extends StatefulWidget {
  final String idSend;

  ContainerLabelDreams(this.idSend);
  @override
  State<ContainerLabelDreams> createState() => _ContainerLabelDreamsState();
}

class _ContainerLabelDreamsState extends State<ContainerLabelDreams> {
  List<String> hours = [
    "0 horas y 30 minutos",
    "01 horas y 05 minutos",
    "07 horas y 15 minutos",
  ];

  List<String> exercises = [
    "Siesta de la tarde",
    "Siesta de la tarde",
    "Sueño Cotidiano"
  ];
  DataBaseHelper httpHelper = new DataBaseHelper();

  List<dynamic> sleepList = [];
  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    final token = await UserSecureStorage.getToken() ?? '';
    final userId = await UserSecureStorage.getUserId() ?? '';

    sleepList =
        await httpHelper.getSleepsRecords(widget.idSend, name, password);

    print("sleepList: " + sleepList.toString());
    print("first: " + sleepList[0].toString());
    print("startDate first: " + sleepList[0]["startDate"].toString());
    print("size: " + sleepList.length.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        for (int i = 0; i < sleepList.length; i++)
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height / 6,
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(246, 239, 227, 10),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                // ajust el tamaño de la columna
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Dormí un total de: " +
                              sleepList[i]["duration"].toString() +
                              " horas",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              tooltip: "Opciones",
                              /*onSelected: (String value) {
                                    if (value == "Eliminar") {
                                      dataBaseHelper.deleteReminder(
                                          remindersList[i]['id']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReminderPage(widget.idSend)));
                                    }
                                  },*/
                              //padding: EdgeInsets.zero,
                              icon: Icon(Icons.more_horiz),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: "Modificar",
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text("Modificar"),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: "Eliminar",
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text("Eliminar"),
                                      ),
                                    )
                                  ]))
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Me fui a dormir a las: " +
                            sleepList[i]["startDate"].toString(),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Me desperté a las: " +
                            sleepList[i]["endDate"].toString(),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Dormí un total de: " +
                            sleepList[i]["duration"].toString() +
                            " horas",
                      )),
                  // negrita
                ],
              ),
            ),
          )
      ],
    ));
  }
}

class ListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(254, 227, 211, 10),
          borderRadius: BorderRadius.circular(9.0)),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: Color.fromRGBO(219, 167, 138, 10),
          ),
          Flexible(
            child: Text(
              "A",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
