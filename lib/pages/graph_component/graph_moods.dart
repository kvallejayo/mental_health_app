// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/endpoints.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:mental_health_app/components/my_labels.dart';
import 'package:mental_health_app/models/MoodTracker.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/themes/my_colors.dart';


class GraphMoodsPage extends StatefulWidget {
  final String idSend;

  GraphMoodsPage(this.idSend);
  
  @override
  State<GraphMoodsPage> createState() => _GraphMoodsPageState();
}

class _GraphMoodsPageState extends State<GraphMoodsPage> {
  final List<dynamic> moods = ["Happy", "Scare", "Sad", "Angry", "Disgust"];
  final List<dynamic> emociones = ["Alegria", "Miedo", "Tristeza", "Enojo", "Asco"];

  DataBaseHelper db = DataBaseHelper();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final int nroDayJump = 7;
  String selectedMoodTracker = "";

  Future<MoodTracker> updateMoodTracker(MoodTracker moodTracker) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    return await db.updateMoodTracker(widget.idSend, username, password, moodTracker);
  }
  Future<Map<String, dynamic>> getMoodTrackersData() async {

    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';

    List<MoodTracker> moodTrackerList = await db.getAllMoodTrackersByUserIdAndMoodTrackerDateRange(
        widget.idSend,
        username,
        password,
        DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: 1))),
        DateFormat('yyyy-MM-dd').format(endDate.add(Duration(days: 1)))
    );
    int totalCount = 0;

    Map<String, dynamic> moodTrackerDataMap = {
      "moodTrackerList": moodTrackerList,
      "counters": {
        "happy": 0,
        "scare": 0,
        "sad": 0,
        "angry": 0,
        "disgust": 0,
      }
    };
    for (var moodTracker in moodTrackerList) {
      moodTrackerDataMap["counters"][moodTracker.mood.toLowerCase()] +=1;
      totalCount+=1;
    }
    moodTrackerDataMap["counters"]["total_count"] = totalCount;
    return moodTrackerDataMap;
  }

  Future init() async {
    endDate = DateTime.now();
    startDate = endDate.subtract(Duration(days: nroDayJump));
    setState(() {
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage('assets/fondos/x cada grafica.png'),
            SingleChildScrollView(
              child: Column(
                children: [
                  TitleHeader("Mis Emociones"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getMoodTrackersData(),
                          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot){
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator(),);
                            }
                            Map<String, dynamic>? moodTrackerDataMap = snapshot.data;
                            //print(moodTrackerDataMap?["moodTrackerList"][0].message);
                            if(moodTrackerDataMap?["moodTrackerList"].length == 0){
                              return Text("Aun no se ha registrado emociones");
                            }
                            return Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Mis emociones de la semana",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                WeeklyMoodsPieChart(moodTrackerDataMap!, startDate, endDate),

                                SizedBox(height: 20,),

                                Column(
                                  children: [
                                    Container(
                                      width: screenWidth,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Lo mas reciente",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    SizedBox(height: 10,),

                                    Container(
                                      width: screenWidth,
                                      alignment: Alignment.center,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index){
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MoodTrackerListTile(moodTrackerDataMap["moodTrackerList"][index]),
                                          );
                                        },
                                        itemCount: moodTrackerDataMap["moodTrackerList"].length ?? 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigation(
        isTheSameGraph: false,
        graphColorIcon: false,
        idSend: widget.idSend,
      ),
    );
  }

  void goBackDateRangeNavigation(){
    startDate = startDate.subtract(Duration(days: nroDayJump));
    endDate = endDate.subtract(Duration(days: nroDayJump));
    setState(() {});
  }
  void goForwardDateRangeNavigation(){
    if (endDate != DateTime.now()){
      startDate = startDate.add(Duration(days: nroDayJump));
      endDate = endDate.add(Duration(days: nroDayJump));
    }
    setState(() {});
  }

  Widget WeeklyMoodsPieChart(Map<String, dynamic> moodTrackerDataMap, DateTime startDate, DateTime endDate){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 350,
                height: 30,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                          ),
                        ),
                        onTap: (){
                          goBackDateRangeNavigation();
                        },
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: waterGreen,
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        child: Text(
                          "${DateFormat.MMMMd('es_ES').format(startDate.add(Duration(days: 1)))}"
                              " - ${DateFormat.MMMMd('es_ES').format(endDate)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                        ),
                        onTap: (){
                          goForwardDateRangeNavigation();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: [
                              PieChartSectionData(
                                value: (moodTrackerDataMap["counters"]["happy"] ?? 0).toDouble(),
                                color: Color.fromRGBO(254, 214, 93, 1),
                                radius: 85,
                                title: "${((moodTrackerDataMap["counters"]["happy"]??0) / (moodTrackerDataMap["counters"]["total_count"] == 0 ? 1: moodTrackerDataMap["counters"]["total_count"]??1) * 100).toStringAsFixed(1)}%",
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(
                                        1.5,
                                        2,
                                      ),
                                    ),
                                  ],
                                ),
                                showTitle: true,
                              ),
                              PieChartSectionData(
                                value: (moodTrackerDataMap["counters"]["scare"] ?? 0).toDouble(),
                                color: Color.fromRGBO(204, 167, 215, 1),
                                radius: 85,
                                title: "${((moodTrackerDataMap["counters"]["scare"]??0) / (moodTrackerDataMap["counters"]["total_count"] == 0 ? 1: moodTrackerDataMap["counters"]["total_count"]??1) * 100).toStringAsFixed(1)}%",
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(
                                        1.5,
                                        2,
                                      ),
                                    ),
                                  ],
                                ),
                                showTitle: true,
                              ),
                              PieChartSectionData(
                                value: (moodTrackerDataMap["counters"]["sad"] ?? 0).toDouble(),
                                color: Color.fromRGBO(130, 193, 255, 1),
                                radius: 85,
                                title: "${((moodTrackerDataMap["counters"]["sad"]??0) / (moodTrackerDataMap["counters"]["total_count"] == 0 ? 1: moodTrackerDataMap["counters"]["total_count"]??1) * 100).toStringAsFixed(1)}%",
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(
                                        1.5,
                                        2,
                                      ),
                                    ),
                                  ],
                                ),
                                showTitle: true,
                              ),
                              PieChartSectionData(
                                value: (moodTrackerDataMap["counters"]["angry"] ?? 0).toDouble(),
                                color: Color.fromRGBO(255, 82, 107, 1),
                                radius: 85,
                                title: "${((moodTrackerDataMap["counters"]["angry"]??0) / (moodTrackerDataMap["counters"]["total_count"] == 0 ? 1: moodTrackerDataMap["counters"]["total_count"]??1) * 100).toStringAsFixed(1)}%",
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(
                                        1.5,
                                        2,
                                      ),
                                    ),
                                  ],
                                ),
                                showTitle: true,
                              ),
                              PieChartSectionData(
                                value: (moodTrackerDataMap["counters"]["disgust"] ?? 0).toDouble(),
                                color: Color.fromRGBO(148, 196, 127, 1),
                                radius: 85,
                                title: "${((moodTrackerDataMap["counters"]["disgust"]??0) / (moodTrackerDataMap["counters"]["total_count"] == 0 ? 1: moodTrackerDataMap["counters"]["total_count"]??1) * 100).toStringAsFixed(1)}%",
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(
                                        1.5,
                                        2,
                                      ),
                                    ),
                                  ],
                                ),
                                showTitle: true,
                              ),
                            ],
                            borderData: FlBorderData(show: false,),
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < moodTrackerDataMap["counters"].length - 1; i++)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/sentimientos/${moods[i].toLowerCase()}.png",
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          emociones[i],
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "${moodTrackerDataMap["counters"].values.elementAt(i)} veces",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
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
  }


  Future<void> deleteMoodTracker(String moodTrackerId) async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    await db.deleteMoodTracker(moodTrackerId, widget.idSend, username, password);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => GraphMoodsPage(widget.idSend)));
  }

  Widget MoodTrackerListTile(MoodTracker moodTracker){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [

                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.all(1),
                  child: Text(
                    DateFormat.MMMMd('es_US').add_jm().format(DateTime.parse(moodTracker.moodTrackerDate)),
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 25,
                    child: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      tooltip: "Opciones",
                      icon: Icon(Icons.more_horiz),
                      onSelected: (String value) {
                        if (value == "Modificar") {
                          selectedMoodTracker = moodTracker.mood;
                          showModifyDialog(moodTracker);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "Modificar",
                          child: ListTile(
                            leading: Icon(
                              Icons.edit,
                              color: Color.fromRGBO(139, 168, 194, 10),
                            ),
                            title: Text(
                              "Modificar",
                              style: TextStyle(color: Color.fromRGBO(139, 168, 194, 10),),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "Eliminar",
                          child: ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: Text("Eliminar", style: TextStyle(color: Colors.redAccent),),
                          ),
                          onTap: () async {
                            await deleteMoodTracker(moodTracker.id.toString());
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/sentimientos/${moodTracker.mood.toLowerCase()}.png",
                        ),
                      ),
                    ),
                  ),

                  SizedBox( width: 17,),

                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        moodTracker.message,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showModifyDialog(MoodTracker moodTracker) async {
    await showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Me siento..."),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: Wrap(
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for(int i = 0; i < moods.length; i++)
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: selectedMoodTracker == moods[i] ? waterGreen : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Image.asset('assets/sentimientos/${moods[i].toLowerCase()}.png'),
                                      onPressed: () async {
                                        selectedMoodTracker = moods[i];
                                        setState(() { });
                                      },
                                    ),
                                  ),
                                  Text(
                                    emociones[i],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(
                        child: Text("MODIFICAR EMOCIÓN"),
                        style: ElevatedButton.styleFrom(
                          primary: waterGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: ()async{
                          moodTracker.mood = selectedMoodTracker;
                          await updateMoodTracker(moodTracker);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          "CANCELAR",
                          style: TextStyle(color: Color(0xFF686EAE),),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: (){Navigator.pop(context);},
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }
}