// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/components/background_image.dart';
import 'package:mental_health_app/components/bottom_navigation_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mental_health_app/components/my_calendar.dart';
import 'package:mental_health_app/security/user_secure_storage.dart';
import 'package:mental_health_app/utils/endpoints.dart';

class GraphExercisesPage extends StatefulWidget {
  final String userId;

  GraphExercisesPage(this.userId);
  @override
  State<GraphExercisesPage> createState() => _GraphExercisesPageState();
}

class _GraphExercisesPageState extends State<GraphExercisesPage> {

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
  );

  DataBaseHelper httpHelper = DataBaseHelper();
  Future init() async {
    setState(() {});
  }

  Future<List<dynamic>> fetchExercisesData() async {
    final username = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';

    String strStartDate = DateFormat("yyyy-MM-dd").format(dateRange.start);
    String strEndDate = DateFormat("yyyy-MM-dd").format(dateRange.end.add(Duration(days: 1)));

    List<dynamic> exercisesList = await httpHelper.getExercisesByUserIdAndDateRange(
        widget.userId,
        username,
        password,
        strStartDate,
        strEndDate
    );

    return exercisesList;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              BackgroundImage('assets/fondos/x cada grafica.png'),
              Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Tiempos de ejercicio",
                        style: TextStyle(
                          color: Color(0xFF615987),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),

                  SizedBox( height: 10,),

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder(
                      future: fetchExercisesData(),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                        if (snapshot.hasData){
                          List? exerciseRecordsList = snapshot.data;

                          return Column(
                            children: [

                              MyCalendar(
                                focusedDay: DateTime.now(),
                                dateRange: dateRange,
                                onRangeSelected: (selectedDateRange){
                                  dateRange = DateTimeRange(start: selectedDateRange!.start, end: selectedDateRange.end);
                                  setState(() {});
                                },
                              ),

                              SizedBox(height: 10,),

                              ExerciseBarsGraph(exerciseRecordsList!, dateRange),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
          isTheSameGraph: false,
          graphColorIcon: false,
          idSend: widget.userId
      ),
    );
  }


  List<dynamic> getExercisesFrequency(List<dynamic> exerciseRecordsList){

    List<dynamic> frequencyList = [
      { "day": "MONDAY", "mins": 0.0, "barColor": Color(0xFFEDB6D3) },
      { "day": "TUESDAY", "mins": 0.0, "barColor": Color(0xFFF8C77F) },
      { "day": "WEDNESDAY", "mins": 0.0, "barColor": Color(0xFFA7CFCF) },
      { "day": "THURSDAY", "mins": 0.0, "barColor": Color(0xFFDD6375) },
      { "day": "FRIDAY", "mins": 0.0, "barColor": Color(0xFF94C47F) },
      { "day": "SATURDAY", "mins": 0.0, "barColor": Color(0xFF82C1FF) },
      { "day": "SUNDAY", "mins": 0.0, "barColor": Color(0xFFC4A0CF) },
    ];

    for (var exerciseRecord in exerciseRecordsList){
      for (var element in frequencyList) {
        if(element["day"] == exerciseRecord["dayOfTheWeek"]){
          element["mins"] += double.parse(exerciseRecord["duration"]);
        }
      }
    }
    return frequencyList;
  }

  Widget ExerciseBarsGraph(List<dynamic> exerciseRecordsList, DateTimeRange dateRange){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Grafico de registro Ejercicios",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        SizedBox(height: 20,),

        Container(
          width: 420,
          height: 250,
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
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: "Horas de ejercicio registradas",
              format: 'El día point.x se realizó point.y horas de ejercicio',
            ),
            series: [
              ColumnSeries<dynamic, String>(
                dataSource: getExercisesFrequency(exerciseRecordsList),
                xValueMapper: (data, _) => data["day"],
                yValueMapper: (data, _) => data["mins"]!.toDouble(),
                pointColorMapper: (data, _) => data["barColor"],

                dataLabelMapper: (data, _) => "${data["mins"]!.toStringAsFixed(1).toString()} mins",
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),

                enableTooltip: true,
                width: 1,
                spacing: 0.1,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
              ),
            ],
          ),
        ),

        SizedBox( height: 15,),

        /*
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            "Datos del ${DateFormat.MMMMd('es_ES').format(dateRange.start)}\nal ${DateFormat.MMMMd('es_ES').format(dateRange.end)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

         */
      ],
    );
  }

}
