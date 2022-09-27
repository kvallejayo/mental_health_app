// ignore_for_file: non_constant_identifier_names, duplicate_ignore, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pages/loading.dart';
import '../components/my_input_field.dart';
import '../themes/my_colors.dart';
import '../utils/endpoints.dart';
import '../pages/home.dart';
import '../security/user_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //using dataBaseHelper from main.dart
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  late bool isPasswordVisible = false;
  bool isLoading = false;

  Future<int> signIn() async {
    var auth = await dataBaseHelper.authenticate(
      controllerUsername.text.trim(),
      controllerPassword.text.trim(),
    );
    await UserSecureStorage.setUsername(controllerUsername.text);
    await UserSecureStorage.setPassword(controllerPassword.text);
    await UserSecureStorage.setToken(auth.toString());
    int id = await dataBaseHelper.authenticateToGetId(controllerUsername.text.trim(), controllerPassword.text.trim());
    await UserSecureStorage.setUserId(id.toString());
    return id;
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingPage() : WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        //evitar el error de botoom overflow by n pixels
        resizeToAvoidBottomInset: false,
        //el teclado no sobreponga los componentes
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/fondos/sign in.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 520,
                  height: 280,
                  width: 320,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/inicio/login.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                              color: Color.fromRGBO(67, 58, 108, 10),
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      MyInputField(
                        labelText: "Usuario",
                        controller: controllerUsername,
                      ),
                      SizedBox(height: 20,),
                      MyInputField(
                        labelText: "Contraseña",
                        isPasswordField: true,
                        controller: controllerPassword,
                        obscureText: true,
                      ),

                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text("¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: Color.fromRGBO(146, 150, 187, 10), fontSize: 15.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ForgotPassword()),
                            ).then((value) => setState(() {}));
                          },
                        ),
                      ),

                      SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(350, 45),
                          backgroundColor: waterGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          "INICIAR SESION",
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          int userId = await signIn();
                          if (userId == null) {
                            Fluttertoast.showToast(
                              msg: "Usuario o contraseña incorrectos",
                              toastLength: Toast.LENGTH_LONG,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage(userId.toString())),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: softPurple,
                          fixedSize: Size(350, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          "¿ERES NUEVO? CREA UNA NUEVA CUENTA",
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pushNamed('/newAccount');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar contraseña"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(232, 227, 238, 10),
                  filled: true,
                  labelText: "Correo electrónico",
                  labelStyle:
                      const TextStyle(color: Color.fromRGBO(146, 150, 187, 10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 3, color: Color.fromRGBO(232, 227, 238, 10)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  )),
              controller: email,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: waterGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(13),
                child: Text(
                  "ENVIAR",
                  style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                if (email.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content:
                          const Text("Ingrese un correo electrónico"),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Aceptar"),
                            )
                          ],
                        );
                      });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Envío de correo"),
                        content: const Text("Se ha enviado un correo"),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Aceptar"),
                          )
                        ],
                      );
                    }
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
