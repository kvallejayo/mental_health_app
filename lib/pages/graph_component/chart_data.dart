import 'dart:ui';

class ChartData {
  ChartData(this.x, this.y, this.pointColorMapper);
  final String x;
  final double? y;
  final Color pointColorMapper;
}