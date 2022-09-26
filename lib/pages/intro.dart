// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../themes/my_colors.dart';
import 'loading.dart';

class IntroPage extends StatefulWidget {
  bool isLoading = true;
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Timer(Duration(seconds: 3), () {
      setState(() {
        widget.isLoading = false;
      });
    });
    return widget.isLoading ? LoadingPage() : Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/fondos/Intro 1.png'),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                      child: ImageSlideshow(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    initialPage: 0,
                    indicatorColor: Colors.blue,
                    indicatorBackgroundColor: Colors.grey,
                    children: [
                      Image.asset(
                        'assets/inicio/1.png',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/inicio/2.png',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/inicio/3.png',
                        fit: BoxFit.cover,
                      ),
                    ],
                    onPageChanged: (value) {
                      print('Page changed: $value');
                    },
                    isLoop: false,
                  )),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Rest(context),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget Rest(BuildContext context) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: const Text(
              "Mejora en los estudios, empezando el primer cambio en ti",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(67, 58, 108, 10),
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: MakeTheFirstMove(context),
      ),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: IAlreadyHaveAnAccount(context))
    ],
  );
}

Widget MakeTheFirstMove(BuildContext context) {
  return Container(
    width: 250,
    height: 70,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: waterGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/newAccount');
      },
      child: const Text("Dar el primer paso",
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget IAlreadyHaveAnAccount(BuildContext context) {
  //cambiar a boton
  return Container(
    alignment: Alignment.center,
    child: TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/login');
      },
      child: Text("YA TENGO UNA CUENTA",
        style: TextStyle(
          color: Color.fromRGBO(104, 110, 174, 10),
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
