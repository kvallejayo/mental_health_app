// ignore_for_file: deprecated_member_use, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_input_field.dart';
import 'package:mental_health_app/models/Affimation.dart';
import 'package:mental_health_app/pages/positive_reinforcement_component/modify_affirmation.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../themes/my_colors.dart';


class PositiveReinforcementPage extends StatefulWidget {
  final String userId;

  const PositiveReinforcementPage(this.userId);
  @override
  State<PositiveReinforcementPage> createState() => _PositiveReinforcementPageState();
}

class _PositiveReinforcementPageState extends State<PositiveReinforcementPage> {

  //late final LocalNotificationService notificationService;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  bool masterSwitch = true;
  Week currentWeek = Week.fromISOString(Week.current().toString());

  List<String> DiasSemana = [
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado",
    "Domingo",
  ];

  List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  Future<void> updateUserAffirmationsPreferenceData(List<dynamic> affirmationsList) async {

    for (var affirmation in affirmationsList){
      affirmation["alarmProperties"]["fireTime"] = affirmation["alarmProperties"]["fireTime"].toString();
      for(var day in weekDays){
        if (affirmation["alarmProperties"][day.toLowerCase()] != null){
          affirmation["alarmProperties"][day.toLowerCase()] = affirmation["alarmProperties"][day.toLowerCase()].toString();
        }
      }
    }
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);
    Map<String, dynamic> userData = userDataStr == null ? {} : jsonDecode(userDataStr);
    userData["affirmationsData"] = affirmationsList;
    await pref.setString(widget.userId, jsonEncode(userData));
  }

  Future<List<dynamic>> getAffirmationsPreferenceData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataStr = pref.getString(widget.userId);

    if (userDataStr == null){
      return [];
    }

    Map<String, dynamic>? userData = jsonDecode(userDataStr);
    List affirmationsList = userData?["affirmationsData"];

    /*
    print("CURRENT AFFIRMATION LIST");
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    log(encoder.convert(affirmationsList));

     */

    return affirmationsList;
  }

  Future<List<Affirmation>> fetchAffirmationsData() async {
    final userName = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await dataBaseHelper.getAffirmations(widget.userId, userName, password);
  }

  Map<String, dynamic> emptyAlarmProperties = {
    "monday": null,
    "tuesday": null,
    "wednesday": null,
    "thursday": null,
    "friday": null,
    "saturday": null,
    "sunday": null,
    "fireTime": DateTime.now(),
    "enable": true,
  };

  Future<void> checkAffirmationsPreferenceData() async {

    List? affirmationsList = await fetchAffirmationsData();
    if (affirmationsList.isEmpty){
      return;
    }
    List? affirmationsAndAlarmsData = await getAffirmationsPreferenceData();
    if (affirmationsAndAlarmsData.isEmpty){
      // CREATING NEW DATA FOR FETCHED AFFIRMATIONS
      List affirmationsAndAlarmsData = affirmationsList.map((affirmation) => affirmation.toJson()).toList();
      for (int i = 0; i < affirmationsAndAlarmsData.length; i++){
        affirmationsAndAlarmsData[i]["alarmProperties"] = emptyAlarmProperties;
      }
      updateUserAffirmationsPreferenceData(affirmationsAndAlarmsData);
      return;
    }

    for (int i = 0; i < affirmationsList.length; i++){
      if (affirmationsList[i].id == affirmationsAndAlarmsData[i]["id"]){
        affirmationsAndAlarmsData[i]["message"] = affirmationsList[i].message;
      }
    }
    updateUserAffirmationsPreferenceData(affirmationsAndAlarmsData);

  }

  Future<void> deleteLocalAffirmationsData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  bool canCreate = false;
  bool isCreateButtonActive = true;

  late Map<String, dynamic> newAlarmProperties;
  List<dynamic> affirmationsList = [];

  Future init() async {
    //await deleteLocalAffirmationsData();
    await checkAffirmationsPreferenceData();
    setState(() {});
  }

  @override
  void initState() {
    //notificationService = LocalNotificationService();
    //notificationService.initializa();
    newAlarmProperties = emptyAlarmProperties;
    init();
    super.initState();
  }

  static void fireAlarm(){
    print(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/fondos/afirmaciones-reforzamiento.png',
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: FutureBuilder(
                    future: getAffirmationsPreferenceData(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                      if (snapshot.hasData){
                        affirmationsList = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                "Afirmaciones",
                                style: TextStyle(
                                  color: Color.fromRGBO(67, 58, 108, 10),
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 410,
                                child: Divider(
                                  color: Color.fromRGBO(146, 150, 187, 10),
                                  thickness: 1,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  "Afirmaciones personalizadas",
                                  style: TextStyle(
                                    color: Color.fromRGBO(146, 150, 187, 10),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              NewAffirmationForm(affirmationsList),

                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: const Text(
                                  "Mis Afirmaciones",
                                  style: TextStyle(
                                    color: Color.fromRGBO(146, 150, 187, 10),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: MyAffirmationsList(affirmationsList),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text("Configuración",
                                  style: TextStyle(
                                    color: Color.fromRGBO(146, 150, 187, 10),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                    color: Color.fromRGBO(250, 233, 207, 1),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Recibir afirmaciones diarias.",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      CupertinoSwitch(
                                        value: masterSwitch,
                                        onChanged: (value) {
                                          setState(() {
                                            actionMasterSwitch(value);
                                            masterSwitch = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(idSend: widget.userId),
    );
  }

  Future<void> actionMasterSwitch(bool value) async {
    List? affirmationsList = await getAffirmationsPreferenceData();
    for (int i = 0; i < affirmationsList.length; i++){
      affirmationsList[i]["alarmProperties"]["enable"] = value;
    }
    updateUserAffirmationsPreferenceData(affirmationsList);
  }

  final TextEditingController message = TextEditingController();
  Future<void> createNewAffirmation(Map<String, dynamic> alarmProperties) async {

    var userName = await UserSecureStorage.getUsername();
    var password = await UserSecureStorage.getPassword();
    Affirmation newAffirmation = await dataBaseHelper.createAffirmation(
        widget.userId,
        userName.toString(),
        password.toString(),
        Affirmation(
          message: message.text,
          creationDate: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        ),
    );

    Map<String, dynamic> newAffirmationJson = newAffirmation.toJson();
    newAffirmationJson["alarmProperties"] = alarmProperties;

    List? affirmationsList = await getAffirmationsPreferenceData();
    affirmationsList.add(newAffirmationJson);
    updateUserAffirmationsPreferenceData(affirmationsList);
  }
  Widget NewAffirmationForm(List<dynamic> affirmationsList) {

    if(newAlarmProperties["fireTime"].runtimeType == String){
      newAlarmProperties["fireTime"] = DateTime.parse(newAlarmProperties["fireTime"]);
    }

    return Container(
      width: MediaQuery.of(context).size.width - 45,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
          ],
          color: Color.fromRGBO(193, 222, 228, 10),
          borderRadius: BorderRadius.circular(9.0)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyInputField(
              controller: message,
              labelText: "Escribe tu afirmación",
              hintInsteadOfLabel: true,
              backgroundColor: Colors.white,
              borderColor: waterGreen,
            ),

            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < DiasSemana.length; i++)
                      Padding(
                        padding: EdgeInsets.all(2.9),
                        child: GestureDetector(
                          child: Container(
                            width: 28,
                            height: 28,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: newAlarmProperties[weekDays[i].toLowerCase()] != null ? waterGreen : Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: waterGreen, width: 1)
                            ),
                            child: Center(
                              child: Text(
                                DiasSemana[i][0],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: newAlarmProperties[weekDays[i].toLowerCase()] != null ? Colors.white : waterGreen,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (newAlarmProperties[weekDays[i].toLowerCase()] == null){
                              newAlarmProperties[weekDays[i].toLowerCase()] = "Active";
                            } else {
                              newAlarmProperties[weekDays[i].toLowerCase()] = null;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                  ],
                ),
                MyDatePickerButton(
                  dateTime: newAlarmProperties["fireTime"],
                  colorTheme: waterGreen,
                  onPickedTime: (pickedTime){
                    newAlarmProperties["fireTime"] = pickedTime;
                    setState(() {});
                  },
                ),
              ],
            ),

            SizedBox(height: 10,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF68AEAE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(13),
                child: Text(
                  "AÑADIR AFIRMACION",
                  style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: isCreateButtonActive ? () async {

                for(int i = 0 ; i < weekDays.length; i++){
                  if(newAlarmProperties[weekDays[i].toLowerCase()] == "Active"){
                    canCreate = true;
                  }
                }
                if(canCreate){

                  setState(() {isCreateButtonActive = false;});

                  DateTime fireTime = newAlarmProperties["fireTime"];

                  for (int i = 0 ; i < weekDays.length; i++){
                    if(newAlarmProperties[weekDays[i].toLowerCase()] == "Active"){
                      DateTime date = currentWeek.day(i);
                      newAlarmProperties[weekDays[i].toLowerCase()] = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        fireTime.hour,
                        fireTime.minute,
                      );
                    }
                  }
                  await createNewAffirmation(newAlarmProperties).then((value) => null);
                } else {
                  Fluttertoast.showToast(msg: "Seleccione al menos un día", toastLength: Toast.LENGTH_LONG);
                }
                newAlarmProperties = emptyAlarmProperties;
                message.text = "";
                canCreate = false;
                isCreateButtonActive = true;

                setState(() {});

              } : null,
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }


  Widget MyAffirmationsList(List<dynamic> affirmationsList){
    if (affirmationsList.isEmpty){
      return Center(
        child: Text(
          "Aún no tienes afirmaciones",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: affirmationsList.length,
      itemBuilder: (context, index){
        return Container(
          child: AffirmationTile(context, affirmationsList[index], index),
        );
      },
    );
  }

  Future<void> updateAffirmationInLocalData(int affirmationIndex, Map affirmationMap) async {
    List? affirmationsList = await getAffirmationsPreferenceData();
    affirmationsList[affirmationIndex] = affirmationMap;
    updateUserAffirmationsPreferenceData(affirmationsList);

  }
  Future<void> removeAffirmationFromList(int affirmationIndex) async {
    List? affirmationsList = await getAffirmationsPreferenceData();
    affirmationsList.removeAt(affirmationIndex);
    updateUserAffirmationsPreferenceData(affirmationsList);
  }

  Widget AffirmationTile (BuildContext context, Map<String, dynamic> affirmationMap, int affirmationIndex){
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: 7),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                    tooltip: "Opciones",
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.more_horiz),
                    ),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: "Modificar",
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Modificar"),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "Eliminar",
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("Eliminar"),
                        ),
                      ),
                    ],
                    onSelected: (String value) async {
                      if (value == "Modificar") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModifyAffirmation(
                            userId: widget.userId,
                            affirmation: Affirmation.fromJson(affirmationMap),
                          ),),
                        ).then((value) async {
                          checkAffirmationsPreferenceData();
                          setState(() {});
                        });
                      } else if (value == "Eliminar") {

                        Fluttertoast.showToast(
                          msg: "Afirmacion eliminada",
                          fontSize: 18,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.black87,
                        );

                        final username = await UserSecureStorage.getUsername() ?? '';
                        final password = await UserSecureStorage.getPassword() ?? '';

                        await removeAffirmationFromList(affirmationIndex);
                        await dataBaseHelper.deleteAffirmation(affirmationMap["id"].toString(), widget.userId, username, password);

                        setState(() {});
                      }
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.favorite,
                        color: Color.fromRGBO(219, 106, 106, 1)
                    ),
                  ),

                  Expanded(
                    child: Text(
                      affirmationMap["message"].toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  CupertinoSwitch(
                    value: affirmationMap["alarmProperties"]["enable"],
                    onChanged: (value) async {
                      affirmationMap["alarmProperties"]["enable"] = value;
                      await updateAffirmationInLocalData(affirmationIndex, affirmationMap);
                      setState(() {});
                    },
                  ),
                ],
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeekDaysButtonsRow(context, affirmationMap, affirmationIndex),
                  MyDatePickerButton(
                    dateTime: DateTime.parse(affirmationMap["alarmProperties"]["fireTime"]),
                    colorTheme: intensePurple,
                    onPickedTime: (pickedTime){
                      //TODO: ESTE MODIFICAR
                      print(pickedTime);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget WeekDaysButtonsRow(BuildContext context, Map affirmationMap, int affirmationIndex){
    return Row(
      children: [
        for (int i = 0; i < DiasSemana.length; i++)
          Padding(
            padding: EdgeInsets.all(2.9),
            child: GestureDetector(
              child: Container(
                width: 28,
                height: 28,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: affirmationMap["alarmProperties"][weekDays[i].toLowerCase()] != null ? intensePurple : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: intensePurple, width: 1)
                ),
                child: Center(
                  child: Text(
                    DiasSemana[i][0],
                    style: TextStyle(
                      fontSize: 11,
                      color: affirmationMap["alarmProperties"][weekDays[i].toLowerCase()] != null ? Colors.white : intensePurple,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                if (affirmationMap["alarmProperties"][weekDays[i].toLowerCase()] == null){
                  DateTime date = currentWeek.day(i);
                  affirmationMap["alarmProperties"][weekDays[i].toLowerCase()] = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    DateTime.parse(affirmationMap["alarmProperties"]["fireTime"]).hour,
                    DateTime.parse(affirmationMap["alarmProperties"]["fireTime"]).minute,
                  );
                } else {
                  affirmationMap["alarmProperties"][weekDays[i].toLowerCase()] = null;
                }
                await updateAffirmationInLocalData(affirmationIndex, affirmationMap);
                setState(() {});
              },
            ),
          ),
      ],
    );
  }

  Widget MyDatePickerButton({
    required DateTime dateTime,
    Function(DateTime)? onPickedTime,
    required Color colorTheme,
  }) {
    return GestureDetector(
      child: Container(
        width: 85,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colorTheme,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.jm().format(dateTime),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2,),
            Icon(
              Icons.timer,
              color: Colors.white,
              size: 15,
            ),
          ],
        ),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: colorTheme,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: colorTheme,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedTime  == null) return;

        final newPickedDate = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        onPickedTime!(newPickedDate);
      },
    );
  }

}
