// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/Components/background_image.dart';
import 'package:mental_health_app/Components/bottom_navigation_bar.dart';
import 'package:mental_health_app/Components/my_labels.dart';
import 'package:mental_health_app/pages/profile_component/my_achievements.dart';
import 'package:mental_health_app/pages/profile_component/notifications_settings.dart';
import 'package:mental_health_app/pages/profile_component/profile_information.dart';
import 'package:mental_health_app/pages/profile_component/score_and_levels.dart';
import 'package:mental_health_app/pages/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_elapsed/time_elapsed.dart';

import '../../models/Medal.dart';
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

  Future<Map<String, dynamic>> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);

    if(userData["profileData"] == null){
      //Creating new profile data
      final username = await UserSecureStorage.getUsername() ?? '';
      userData["profileData"] = {
        "username": username,
        "profile_img": "assets/niveles/piezaperfil.png",
        "ranked_img": "assets/niveles/principiante motivado.png",
        "medals": [],
        "mindy_days_counter": 0,
        "score": 0,
        "creation_date": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      };
      await pref.setString(widget.userId, jsonEncode(userData));
      return userData["profileData"];
    }
    //Updating mindy days counter
    var creationDate = DateTime.parse(userData["profileData"]["creation_date"]);
    var daysSinceCreationDate = (DateTime.now().difference(creationDate).inHours / 24).round();
    userData["profileData"]["mindy_days_counter"] = daysSinceCreationDate;

    //Updating medals
    userData["profileData"]["medals"] = await getUserMedalsList(userData["profileData"]);

    //Updating Score
    int score = 0;
    for(var medal in userData["profileData"]["medals"]){
      score = score + int.parse(medal["points_worth"]);
    }
    userData["profileData"]["score"] = score;

    await pref.setString(widget.userId, jsonEncode(userData));
    return userData["profileData"];
  }

  Future<List> getUserMedalsList(Map<String, dynamic> profileData) async {

    List<Medal> medals = [
      Medal(
        message: "1 día usando la aplicación",
        image: "assets/medals/days_in_mindy_1.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 1){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "3 días usando la aplicación",
        image: "assets/medals/days_in_mindy_3.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 3){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "7 días usando la aplicación",
        image: "assets/medals/days_in_mindy_7.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 7){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "15 días usando la aplicación",
        image: "assets/medals/days_in_mindy_15.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 15){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "1 mes usando la aplicación",
        image: "assets/medals/days_in_mindy_1_month.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 30){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "3 meses usando la aplicación",
        image: "assets/medals/days_in_mindy_3_months.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 62){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "6 meses usando la aplicación",
        image: "assets/medals/days_in_mindy_6_months.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 124){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
      Medal(
        message: "1 año usando la aplicación",
        image: "assets/medals/days_in_mindy_1_year.png",
        earnCondition: (){
          if(profileData["mindy_days_counter"] >= 365){
            return true;
          }
          return false;
        },
        pointsWorth: 10,
      ),
    ];

    List<dynamic> userMedals = [];
    //VALIDATING MEDALS
    for(var medal in medals){
      if(medal.earnCondition()){
        Map<String, dynamic> medalData = {
          "message": medal.message,
          "image": medal.image,
          "points_worth": medal.pointsWorth.toString(),
        };
        if(!userMedals.contains(medalData)){
          userMedals.add(medalData);
        }
      }
    }
    return userMedals;
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
