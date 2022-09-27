// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/components/my_input_field.dart';
import 'package:mental_health_app/pages/welcome.dart';

import '../security/user_secure_storage.dart';
import '../themes/my_colors.dart';
import '../utils/endpoints.dart';
import 'loading.dart';

class NewAccountPage extends StatefulWidget {
  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final _formKey = GlobalKey<FormState>();
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerSupervisorEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerRepeatPassword = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerUniversity = TextEditingController();
  final TextEditingController controllerProvince = TextEditingController();
  final TextEditingController controllerDistrict = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingPage() : Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage("assets/fondos/create new account.png"),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Text(
                      "Crear Nueva Cuenta",
                      style: TextStyle(
                        color: Color.fromRGBO(67, 58, 108, 10),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerUsername,
                        labelText: "Usuario",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerEmail,
                        labelText: "Correo Electrónico",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerPassword,
                        labelText: "Contraseña",
                        isPasswordField: true,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerRepeatPassword,
                        labelText: "Repetir contraseña",
                        isPasswordField: true,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerPhone,
                        labelText: "Teléfono",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerUniversity,
                        labelText: "Universidad",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerProvince,
                        labelText: "Provincia",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerDistrict,
                        labelText: "Distrito",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: MyInputField(
                        controller: controllerSupervisorEmail,
                        labelText: "Correo Electrónico de supervisor",
                      ),
                    ),
                    Container(
                      width: 450,
                      height: 70,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: waterGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(13),
                          child: Text(
                            "CREAR CUENTA",
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (validate()) {
                            setState(() { isLoading = true; });
                            await dataBaseHelper.register(
                              controllerUsername.text.trim(),
                              controllerEmail.text.trim(),
                              controllerPassword.text.trim(),
                              controllerPhone.text.trim(),
                              controllerUniversity.text.trim(),
                              controllerProvince.text.trim(),
                              controllerDistrict.text.trim(),
                              controllerSupervisorEmail.text.trim(),
                            );

                            var auth = await dataBaseHelper.authenticate(
                              controllerUsername.text.trim(),
                              controllerPassword.text.trim(),
                            );

                            await UserSecureStorage.setUsername(controllerUsername.text);
                            await UserSecureStorage.setPassword(controllerPassword.text);
                            await UserSecureStorage.setToken(auth.toString());
                            int id = await dataBaseHelper.authenticateToGetId(controllerUsername.text.trim(), controllerPassword.text.trim());
                            await UserSecureStorage.setUserId(id.toString());
                            setState(() { isLoading = true; });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Welcome(userId: id.toString()),),
                            ).then((value) => setState(() {}));

                          } else {
                            Fluttertoast.showToast(
                                msg: "Ocurrió un problema, revise el formulario",
                                toastLength: Toast.LENGTH_LONG
                            );
                          }
                        },
                      ),
                    ),

                    Divider(
                      color: Color.fromRGBO(146, 150, 187, 10),
                      indent: 100,
                      endIndent: 100,
                      thickness: 1,
                    ),
                    Container(
                      child: Container(
                        width: 450,
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: softPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "¿YA TIENES CUENTA? INICIA AHORA",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool validate(){
    if(controllerUsername.text == ""
        || controllerEmail.text == ""
        || controllerPassword.text == ""){
      return false;
    }
    if (controllerPassword.text != controllerRepeatPassword.text){
      return false;
    }
    return true;
  }
}
