import 'package:charts_flutter/flutter.dart' as charts;

class SubscriberSeries{
  final String day;
  final String text;
  final double hours;
  final charts.Color barColor;

  SubscriberSeries({
    required this.day,
    required this.text,
    required this.hours,
    required this.barColor
  });

}