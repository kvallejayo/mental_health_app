// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/Components/bottom_navigation_bar.dart';
import 'package:mental_health_app/Components/my_labels.dart';
import 'package:mental_health_app/pages/profile_component/my_achievements.dart';
import 'package:mental_health_app/pages/profile_component/notifications_settings.dart';
import 'package:mental_health_app/pages/profile_component/profile_information.dart';
import 'package:mental_health_app/pages/profile_component/score_and_levels.dart';
import 'package:mental_health_app/pages/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../security/user_secure_storage.dart';
import '../../themes/my_colors.dart';
import '../../utils/endpoints.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  Future<void> createProfile() async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);
    userData["profileData"] = {
      "username": username,
      "profile_img": "assets/niveles/piezaperfil.png",
      "ranked_img": "assets/niveles/principiante motivado.png",
      "medals": [],
      "mindy_days_counter": 1,
      "score": 0,
    };
    await pref.setString(widget.userId, jsonEncode(userData));
  }

  Future<Map<String, dynamic>> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);

    if(userData["profileData"] == null){
      createProfile();
      return {};
    }
    return userData["profileData"];
  }


  late Map<String, dynamic> profileData;

  Future<void> deleteAccount() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.deleteUser(widget.userId, name, password);
    await UserSecureStorage.setUserId(null);
    await UserSecureStorage.setUsername(null);
    await UserSecureStorage.setPassword(null);
    await UserSecureStorage.setToken(null);
  }

  List<dynamic> configurationOptions = [
    "Mi información personal",
    "Mis logros",
    "Notificaciones",
  ];

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
                  TitleHeader("Mi Perfil"),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getProfile(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot){
                            if(!snapshot.hasData){
                              return SizedBox();
                            }
                            profileData = snapshot.data;
                            print(profileData);
                            return Column(
                              children: [
                                Image.asset(profileData["profile_img"], width: 100,),
                                SizedBox(height: 5,),
                                Text(
                                  profileData["username"],
                                  style: TextStyle(
                                    color: Color(0xFF9F9F9F),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Image.asset(profileData["ranked_img"], width: 220,),
                                SizedBox(height: 20,),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              profileData["medals"].length.toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                            Text(
                                              "Medallas Obtenidas",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              profileData["mindy_days_counter"].toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                            Text(
                                              "Días en Mindy",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              profileData["score"].toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                            Text(
                                              "Puntaje",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF66656C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 15,),
                        H1Label("Configuración"),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: configurationOptions.length,
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0.1,
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(configurationOptions[index]),
                                    trailing: Icon(Icons.arrow_forward_ios)
                                  ),
                                ),
                                onTap: (){
                                  switch (configurationOptions[index]){
                                    case "Mi información personal":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileInformation(userId: widget.userId,),
                                        ),
                                      );
                                      break;
                                    case "Mis logros":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyAchievements(userId: widget.userId, profileData: profileData),
                                        ),
                                      );
                                      break;
                                    case "Notificaciones":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotificationsSettings(userId: widget.userId,),
                                        ),
                                      );
                                      break;
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: Text(
                            "ELIMINAR MI CUENTA",
                            style: TextStyle(
                              color: softRed,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            deleteAccount().then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(),),
                            ));
                          },
                        ),
                      ],
                    ),
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
