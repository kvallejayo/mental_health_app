// @dart=2.9

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mental_health_app/pages/home.dart';
import 'package:mental_health_app/pages/intro.dart';
import 'package:mental_health_app/pages/loading.dart';
import 'package:mental_health_app/pages/new_account.dart';
import 'package:mental_health_app/pages/sign_in.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String loggedUserId = await UserSecureStorage.getUserId();
  initializeDateFormatting('es_ES',null).then((_) => runApp(MyApp(loggedUserId: loggedUserId,)));
}

class MyApp extends StatelessWidget {
  final String loggedUserId;
  MyApp({this.loggedUserId});

  @override
  Widget build(BuildContext context) {
    print("RUNNING");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/newAccount': (context) => NewAccountPage(),
        '/intro': (context) => IntroPage(),
        '/home': (context) => HomePage(loggedUserId),
        '/loading': (context) => LoadingPage(),
      },
      initialRoute: loggedUserId == null ? '/intro' : '/home',
    );
  }
}
