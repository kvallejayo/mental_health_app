import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mental_health_app/components/chart/subscriber_series.dart';

class SubscriberChart extends StatelessWidget {
  final List<SubscriberSeries> data;
  SubscriberChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
        id: "Hours",
        data: data,
        domainFn: (SubscriberSeries series, _) => series.day,
        measureFn: (SubscriberSeries series, _) => series.hours,
        colorFn: (SubscriberSeries series, _) => series.barColor,
        labelAccessorFn: (SubscriberSeries series, _) =>
            '\${series.text}',
      )
    ];
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}
