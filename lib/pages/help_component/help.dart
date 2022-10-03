// ignore_for_file: non_constant_identifier_names, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_dialpad/flutter_dialpad.dart';

class HelpPage extends StatefulWidget {
  final String idSend;

  HelpPage(this.idSend);
  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 1,
                    color: Color(0xFFFEFAEE),
                  ),
                  Column(
                    children: [
                      TitleHeader("Contactar personal"),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Línea de Crisis",
                                style: TextStyle(
                                  color: Color.fromRGBO(146, 150, 187, 10),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DoctorCard(context),
                            SizedBox(height: 15,),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IntrinsicWidth(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Orientación Psicopedagógica",
                                          style: TextStyle(
                                            color: Color(0xFF458181),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Centro de estudios",
                                            style: TextStyle(
                                              color: Color(0xFF9F9F9F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text("Solicitar Ayuda"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFCE6A64),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final url = Uri.parse('https://www.upc.edu.pe/servicios/orientacion-psicopedagogica/');
                                      if (!await launchUrl(url)) {
                                        Fluttertoast.showToast(
                                          msg: 'Error de conexion con $url',
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Consejos",
                                style: TextStyle(
                                    color: Color.fromRGBO(146, 150, 187, 10),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tips(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text("Afirmaciones",
                                  style: TextStyle(
                                      color: Color.fromRGBO(146, 150, 187, 10),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              child: Affirmations(),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget DoctorCard(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3),
          ],
        ),

        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 2),
                    child: Text("Disponible"),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: Image.asset('assets/doctor.jpg'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("MINSA",
                            style: Theme.of(context).textTheme.headline5!.apply(
                                color: Color.fromRGBO(72, 129, 129, 10),
                                fontWeightDelta: 5)),
                        const Text(
                          "Línea de emergencia",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/icons/phone_red.png", width: 30,),
                                  onPressed: (){
                                    FlutterPhoneDirectCaller.callNumber("113");
                                  },
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "113",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(67, 58, 108, 10),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset("assets/icons/clock_white.png", width: 32,),
                                SizedBox(width: 10,),
                                Text(
                                  "24 hrs.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(67, 58, 108, 10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
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

  Widget Tips() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
        ], color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: const [
                  Text(
                    "1. No es momento de tomar decisiones",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: const [
                    Text("2. Habla con alguien"),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: const [
                    Text("3. Intenta mantenerte seguro"),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: const [
                    Text("4. Procura estar acompañado"),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: const [
                    Text("5. Evita consumir alcochol o drogas"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget Affirmations() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
        ], color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(219, 167, 138, 10),
                    ),
                    Flexible(
                      child: Text(
                        '"Puedo encontrar soluciones a mis problemas"',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(219, 167, 138, 10),
                      ),
                      Flexible(
                          child: Text(
                        '"Puedo encontrar nuevos propósitos"',
                        style: TextStyle(fontSize: 14),
                      )),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(219, 167, 138, 10),
                      ),
                      Flexible(
                          child: Text(
                        '"Mis pensamientos y emociones pueden cambiar"',
                        style: TextStyle(fontSize: 14),
                      )),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(219, 167, 138, 10),
                      ),
                      Flexible(
                          child: Text(
                        '"He salido de muchas batallas, esta vez también"',
                        style: TextStyle(fontSize: 14),
                      )),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(219, 167, 138, 10),
                      ),
                      Flexible(
                          child: Text(
                        '"Sé que ha sido duro, pero todavía te estoy animando"',
                        style: TextStyle(fontSize: 14),
                      )),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(219, 167, 138, 10),
                      ),
                      Flexible(
                          child: Text(
                        '"Soy capaz de cosas interesantes"',
                        style: TextStyle(fontSize: 14),
                      )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TelefonoPage extends StatefulWidget {
  final String idSend;
  TelefonoPage(this.idSend);
  @override
  State<TelefonoPage> createState() => _TelefonoPageState();
}

class _TelefonoPageState extends State<TelefonoPage> {
  String display = '113';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 238, 10),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(254, 250, 238, 10),
        selectedItemColor: Color.fromRGBO(104, 174, 174, 10),
        unselectedItemColor: Color.fromRGBO(179, 179, 179, 10),
        selectedFontSize: MediaQuery.of(context).size.width * 0.03,
        unselectedFontSize: MediaQuery.of(context).size.width * 0.03,
        currentIndex: 2,
        onTap: (value) {
          // seleccionar un icono y cambiarle el color
        },
        items: [
          BottomNavigationBarItem(
            label: 'Recientes',
            icon: Icon(Icons.watch_later),
          ),
          BottomNavigationBarItem(
            label: 'Contactos',
            icon: Icon(Icons.account_circle_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Teclado',
            icon: Icon(Icons.keyboard_alt),
          ),
          BottomNavigationBarItem(
            label: 'Favoritos',
            icon: Icon(Icons.star),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: Center(
                  child: Text(
                    display,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.12,
                        color: Colors.black),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                child: Center(
                  child: Text(
                    "Agregar número",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Color.fromRGBO(100, 164, 164, 10)),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.79,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dialPadButton(size, '1', ''),
                        dialPadButton(size, '2', 'ABC'),
                        dialPadButton(size, '3', 'DEF')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dialPadButton(size, '4', 'GHI'),
                        dialPadButton(size, '5', 'JKL'),
                        dialPadButton(size, '6', 'MNO')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dialPadButton(size, '7', 'PQRS'),
                        dialPadButton(size, '8', 'TUV'),
                        dialPadButton(size, '9', 'WXYZ')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dialPadButton(size, '*', ''),
                        dialPadButton(size, '0', '+'),
                        dialPadButton(size, '#', '')
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(142, 209, 171, 10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                            onTap: () {
                              //FlutterPhoneDirectCaller.callNumber(display);
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          InkWell(
                            onTap: () {
                              if (display.length != 0) {
                                setState(() {
                                  display =
                                      display.substring(0, display.length - 1);
                                });
                              }
                            },
                            child: Icon(
                              Icons.backspace,
                              size: MediaQuery.of(context).size.height * 0.08,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dialPadButton(Size size, String value, String value2, {Color? color}) {
    return InkWell(
      highlightColor: Colors.black45,
      onTap: () {
        if (display.length < 9)
          setState(() {
            display = display + value;
          });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.11,
          width: MediaQuery.of(context).size.width * 0.23,
          decoration: BoxDecoration(
              color: Color.fromRGBO(224, 222, 232, 10),
              border: Border.all(color: Colors.grey, width: 0.025),
              shape: BoxShape.circle),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: color ?? Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  value2,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: color ?? Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
