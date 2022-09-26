// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../pages/home.dart';

import '../themes/my_colors.dart';

class Welcome extends StatelessWidget {
  final String userId;
  const Welcome({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/fondos/home.png'
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15,),
                  Image.asset("assets/botImage.png", width: 180,),
                  SizedBox(height: 10,),
                  Text(
                    "Mindy",
                    style: TextStyle(
                      color: Color(0xFF7C7C88),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    width: 300,
                    child: Text(
                      "¡Hola, soy Mindy! Soy tu asistente personal que te acompañará en esta travesía. Antes de comenzar, hay que tener claro que esta aplicación no tienen fines clínicos para diagnosticar un problema de la salud mental. Solo un especialista lo puede hacer.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFDFDEEC),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: waterGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(13),
                      child: Text(
                        "ESTA BIEN, CONINUEMOS!",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => HomePage(userId),),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
