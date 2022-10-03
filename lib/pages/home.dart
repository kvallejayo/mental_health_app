// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Components/bottom_navigation_bar.dart';
import '../components/background_image.dart';
import '../models/MoodTracker.dart';
import '../pages/exercises_components/exercises_record.dart';
import '../pages/graph_component/graphs.dart';
import '../pages/help_component/help.dart';
import '../pages/learn_component/learn.dart';
import '../pages/goals_components/goals.dart';
import '../pages/positive_reinforcement_component/positive_reinforcement.dart';
import '../pages/quiz_component/quiz_selection.dart';
import '../pages/reminder_component/reminders.dart';
import '../pages/respiration_exercises_component/respiration_exercises.dart';
import '../pages/sleep_records_component/sleep_records.dart';
import '../pages/thought_component/thoughts.dart';
import '../security/user_secure_storage.dart';
import '../themes/my_colors.dart';
import '../utils/endpoints.dart';

class HomePage extends StatefulWidget {
  // get id from sign in page

  final String userId;
  late String username;

  HomePage(this.userId);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  late int indexSelectedAffirmation;

  Future<bool?> showWarning(BuildContext context){
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Deseas salir de la aplicación?"),
        actions: [
          ElevatedButton(
            child: Text("No"),
            style: ElevatedButton.styleFrom(
              backgroundColor: waterGreen,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: Text("Si"),
            style: ElevatedButton.styleFrom(
              backgroundColor: waterGreen,
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  Future initAsync() async {
    //await AndroidAlarmManager.initialize();
    setState(() {});
  }

  @override
  void initState() {
    indexSelectedAffirmation = 0;
    initAsync();
    super.initState();
  }

  void createNewMoodTracker(String mood, String message) async {

    final moodTracker = MoodTracker(
        id: 0,
        moodTrackerDate: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        mood: mood,
        message: message
    );

    final password = await UserSecureStorage.getPassword() ?? '';
    await dataBaseHelper.createMoodTracker(
      widget.userId,
      widget.username,
      password,
      moodTracker,
    ).then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {

    List<dynamic> moods = ["Happy", "Scare", "Sad", "Angry", "Disgust"];
    List<dynamic> emociones = ["Alegria", "Miedo", "Tristeza", "Enojo", "Asco"];
    List<dynamic> moodMessages = [
      "Las personas son tan felices como ellas deciden ser. ¡La felicidad es una decisión que debemos tomar cada día!",
      "Sentir es lo más valiente que hay, ¡Sé que ha sido duro, pero todavía estamos de pie! Respira profundo e intentalo de nuevo.",
      "Cuando cambias la manera en que miras las cosas, las cosas que miras, cambiarán también. ¡Tú puedes!",
      "Cuando estés molesto cuenta hasta diez antes de hablar. Si estas muy molesto, cuenta hasta cien.",
      "¡En la vida algunas veces se gana, otras veces se aprende! Si quieres que la vida te sonría, prueba primero tu buen humor.",
    ];

    double moodIconSize = 50;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BackgroundImage("assets/fondos/home.png"),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: UserSecureStorage.getUsername(),
                            builder: (context, AsyncSnapshot snapshot){
                              if(!snapshot.hasData){
                                return SpinKitThreeInOut(color: darkPurple,);
                              }
                              widget.username = snapshot.data;
                              return Text(
                                "Hola ${widget.username}",
                                style: TextStyle(
                                    color: Color.fromRGBO(67, 58, 108, 10),
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/icons/contacto profesional.png'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HelpPage(widget.userId),),
                              ).then((value) => setState(() {}));
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),

                      Text("¿Cómo te sientes ahora?",
                        style: TextStyle(
                          color: Color.fromRGBO(146, 150, 187, 10),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox( height: 5, ),

                      //ROW OF MOOD ICONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for(int i = 0; i < moods.length; i++)
                            Column(
                              children: [
                                IconButton(
                                  icon: Image.asset('assets/sentimientos/${moods[i].toLowerCase()}.png'),
                                  iconSize: moodIconSize,
                                  onPressed: () async {
                                    createNewMoodTracker(moods[i], moodMessages[i]);
                                    Fluttertoast.showToast(
                                      msg: "Se registro su emoción actual: ${emociones[i]}",
                                      fontSize: 16,
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black87,
                                    );
                                  },
                                ),
                                Text(
                                  emociones[i],
                                  style: TextStyle(
                                    color: Color.fromRGBO(115, 112, 108, 10),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      SizedBox(height: 15,),

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
                            "¿TE GUSTARIA TOMAR UN TEST?",
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => QuizSelection(userId: widget.userId, username: widget.username),
                          )).then((value) => setState(() {}));
                        },
                      ),

                      SizedBox(height: 15,),


                      Container(
                        child: Affirmation(context),
                      ),

                      SizedBox(height: 10,),



                      Container(
                        child: ObjectivesRemindersAndDaily(context),
                      ),
                      Container(
                        child: SleepRespirationAndActivities(context),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          isTheSameHome: true,
          homeColorIcon: false,
          idSend: widget.userId,
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchAffirmationData() async {
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getAffirmations(widget.userId, widget.username, password);
  }

  Widget Affirmation(BuildContext context) {

    //var rng = Random();
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Afirmaciones",
            style: TextStyle(
              color: Color.fromRGBO(146, 150, 187, 10),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 5,),

        Container(
          decoration: BoxDecoration(
            color: softPink,
            borderRadius: BorderRadius.circular(9.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
            ],
          ),

          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.more_horiz),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PositiveReinforcementPage(widget.userId),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
                FutureBuilder(
                  future: fetchAffirmationData(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                    if (!snapshot.hasData){
                      return Center(
                        child: SpinKitThreeInOut(color: darkPurple,),
                      );
                    }
                    List? affirmationsList = snapshot.data;
                    print("DATA");
                    print(affirmationsList);
                    return Column(
                      children: [

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            affirmationsList!.isNotEmpty ? '"${affirmationsList[indexSelectedAffirmation].message}"': "No hay afirmaciones",
                            style: TextStyle(
                                color: Color.fromRGBO(67, 58, 108, 10),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/icons/change.png',
                              width: 18,
                              height: 18,
                            ),
                            onPressed: () {
                              indexSelectedAffirmation += 1;
                              if (indexSelectedAffirmation >= affirmationsList.length) {
                                indexSelectedAffirmation = 0;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ObjectivesRemindersAndDaily(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text("Objetivos, recordatorios y diario",
              style: TextStyle(
                  color: Color.fromRGBO(146, 150, 187, 10),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/ilustraciones/objetivos.png',
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Goals(widget.userId),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "OBJETIVOS",
                      style: TextStyle(
                        color: Color.fromRGBO(115, 112, 108, 10),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/ilustraciones/Recordatorios.png',
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reminders(widget.userId),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "RECORDATORIOS",
                      style: TextStyle(
                        color: Color.fromRGBO(115, 112, 108, 10),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/ilustraciones/pensamientos.png',
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Thoughts(userId: widget.userId),),
                        ).then((value) => setState(() {}));
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "PENSAMIENTOS",
                      style: TextStyle(
                        color: Color.fromRGBO(115, 112, 108, 10),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget SleepRespirationAndActivities(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Sueño, respiración y actividades",
            style: TextStyle(
              color: Color.fromRGBO(146, 150, 187, 10),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepRecordsPage(widget.userId),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child: Container(
                      height: 220,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/ilustraciones/sueño.png'),
                          ),
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "REGISTRO DE SUEÑO",
                  style: TextStyle(
                      color: Color.fromRGBO(115, 112, 108, 10),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 8),
                )
              ],
            ),
            Column(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 100,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/ilustraciones/respiración.png',
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RespirationExercises(widget.userId),
                        )).then((value) => setState(() {}));
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "EJERCICIOS DE RESPIRACIÓN",
                      style: TextStyle(
                          color: Color.fromRGBO(115, 112, 108, 10),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 8),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LearnPage(widget.userId))).then((value) => setState(() {}));
                      },
                      child: Container(
                          height: 100,
                          width: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/ilustraciones/más info.png'),
                              ),
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "APRENDER ALGO NUEVO",
                      style: TextStyle(
                          color: Color.fromRGBO(115, 112, 108, 10),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 8),
                    )
                  ],
                )
              ],
            ),
            Column(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExercisesRecordPage(widget.userId))).then((value) => setState(() {}));
                      },
                      child: Container(
                          height: 130,
                          width: 120,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/ilustraciones/ejercicios físicos.png'),
                              ),
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "REGISTRO DE EJERCICIOS FÍSICOS",
                      style: TextStyle(
                          color: Color.fromRGBO(115, 112, 108, 10),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 8),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GraphPage(widget.userId))).then((value) => setState(() {}));
                      },
                      child: Container(
                          height: 80,
                          width: 120,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/ilustraciones/graficas.png'),
                              ),
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "GRÁFICAS",
                      style: TextStyle(
                          color: Color.fromRGBO(115, 112, 108, 10),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 8),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
