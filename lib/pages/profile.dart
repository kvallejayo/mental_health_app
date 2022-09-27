//import 'dart:js';

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mental_health_app/models/User.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/components/my_input_field.dart';
import 'package:mental_health_app/pages/sign_in.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/themes/my_colors.dart';
import '../utils/endpoints.dart';

// pasar como argumento el contexto dataBaseHelper
class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool editProfile = false;
  User? user;

  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPhone = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();
  TextEditingController ctrlUniversity = TextEditingController();
  TextEditingController ctrlProvince = TextEditingController();
  TextEditingController ctrlDistrict = TextEditingController();
  TextEditingController ctrlSupEmail = TextEditingController();

  String password = "";

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  List<dynamic> popUpMenuOptions = [
    {
      "title": "Editar perfil",
      "color": Color(0xFF829AAF),
      "icon": Icons.edit_note,
    },
    {
      "title": "Cerrar sesión",
      "color": softRed,
      "icon": Icons.exit_to_app,
    },
  ];

  Future<User> fetchUser() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getUser(widget.userId, name, password);
  }

  Future<void> deleteAccount() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.deleteUser(widget.userId, name, password);
    await UserSecureStorage.setUserId(null);
    await UserSecureStorage.setUsername(null);
    await UserSecureStorage.setPassword(null);
    await UserSecureStorage.setToken(null);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(),),
    );
  }

  Future<User> updateUser(User user) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    return await dataBaseHelper.updateUser(username, password, user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/profile.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20,),
                        Text(
                          "Mi Perfil",
                          style: TextStyle(
                            color: Color(0xFF615987),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                    size: 28,
                                  ),
                                  title: Text(
                                    popUpMenuOptions[i]["title"],
                                    style: TextStyle(
                                      color: popUpMenuOptions[i]["color"],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],

                          //ACCIONES DISPONIBLES
                          onSelected: (String value) async {
                            switch (value) {
                              case "Editar perfil":
                                setState(() {
                                  editProfile = !editProfile;
                                });
                                break;
                              case "Cerrar sesión":
                                await UserSecureStorage.setUserId(null);
                                await UserSecureStorage.setUsername(null);
                                await UserSecureStorage.setPassword(null);
                                await UserSecureStorage.setToken(null);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),

                  FutureBuilder(
                    future: fetchUser(),
                    builder: (context, AsyncSnapshot<User> snapshot){
                      if(!snapshot.hasData){
                        return Center(child: CircularProgressIndicator(color: waterGreen,));
                      }
                      user = snapshot.data;

                      if(!editProfile){
                        ctrlUsername.text = user!.userName;
                        ctrlEmail.text = user!.email;
                        ctrlPhone.text = user!.phone;
                        ctrlPassword.text = password;
                        ctrlUniversity.text = user!.university;
                        ctrlProvince.text = user!.province;
                        ctrlDistrict.text = user!.district;
                        ctrlSupEmail.text = user!.supervisorEmail;
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            H1Label("Usuario:"),
                            MyInputField(
                              controller: ctrlUsername,
                              enabled: editProfile,
                            ),
                            H1Label("Correo Electrónico:"),
                            MyInputField(
                              controller: ctrlEmail,
                              enabled: editProfile,
                            ),
                            H1Label("Teléfono celular:"),
                            MyInputField(
                              controller: ctrlPhone,
                              enabled: editProfile,
                            ),
                            H1Label("Contraseña:"),
                            MyInputField(
                              controller: ctrlPassword,
                              enabled: editProfile,
                              isPasswordField: true,
                              obscureText: true,
                            ),
                            H1Label("Universidad:"),
                            MyInputField(
                              controller: ctrlUniversity,
                              enabled: editProfile,
                            ),
                            H1Label("Provincia:"),
                            MyInputField(
                              controller: ctrlProvince,
                              enabled: editProfile,
                            ),
                            H1Label("Distrito:"),
                            MyInputField(
                              controller: ctrlDistrict,
                              enabled: editProfile,
                            ),
                            H1Label("Correo Electrónico de supervisor:"),
                            MyInputField(
                              controller: ctrlSupEmail,
                              enabled: editProfile,
                            ),

                            SizedBox(height: 20,),

                            Container(
                              alignment: Alignment.center,
                              child: editProfile ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: waterGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  child: Text(
                                    "ACTUALIZAR PERFIL",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onPressed: () async {

                                  user?.userName = ctrlUsername.text;
                                  user?.email = ctrlEmail.text;
                                  user?.phone = ctrlPhone.text;
                                  user?.password = ctrlPassword.text;
                                  user?.university = ctrlUniversity.text;
                                  user?.province = ctrlProvince.text;
                                  user?.district = ctrlDistrict.text;
                                  user?.supervisorEmail = ctrlSupEmail.text;

                                  await updateUser(user!).then((value) => Alert(
                                    context: context, type: AlertType.success,
                                    title: "MODIFICACIÓN EXITOSA",
                                    desc: "¡Se actualizó con perfil con éxito!",
                                    buttons: [
                                      DialogButton(
                                        color: waterGreen,
                                        child: Text(
                                          "Aceptar",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ).show());
                                  await UserSecureStorage.setUsername(ctrlUsername.text);
                                  await UserSecureStorage.setPassword(ctrlPassword.text);
                                  setState(() {
                                    editProfile = false;
                                  });
                                },
                              ) : TextButton(
                                child: Text(
                                  "ELIMINAR MI CUENTA",
                                  style: TextStyle(
                                    color: softRed,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  await deleteAccount();
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        isTheSameProfile: true,
        profileColorIcon: false,
        idSend: widget.userId,
      ),
    );
  }
}