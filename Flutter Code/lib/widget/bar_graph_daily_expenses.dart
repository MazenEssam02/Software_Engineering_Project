import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraphDailyExpenses extends StatelessWidget {
  BarGraphDailyExpenses({super.key, required this.daysGrouped});
  final List<List<num>> daysGrouped;
  final days = ['Mod', 'Tu', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  Widget build(BuildContext context) {
    final daysGroupedRatio = [...daysGrouped];
    num maxPrice = 0;
    for (List<num> dayExp in daysGroupedRatio) {
      maxPrice = max(maxPrice, dayExp[1]);
    }
    maxPrice *= 1.25;
    for (List<num> dayExp in daysGroupedRatio) {
      dayExp[1] = dayExp[1] / maxPrice;
    }
    return BarChart(
      BarChartData(
        maxY: 1,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                (value * maxPrice).toInt().toString(),
                style: TextStyle(fontSize: 12),
              );
            },
          )),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                days[value.toInt()],
                style: TextStyle(fontSize: 14),
              );
            },
          )),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem((rod.toY * maxPrice).toString(),
                  TextStyle(fontSize: 12, color: rod.color));
            },
          ),
        ),
        barGroups: daysGroupedRatio
            .map<BarChartGroupData>(
              (e) => BarChartGroupData(
                x: e[0].toInt(),
                barRods: [
                  BarChartRodData(
                      toY: e[1].toDouble(),
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                          show: true, toY: 1, color: Colors.grey[200]))
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
