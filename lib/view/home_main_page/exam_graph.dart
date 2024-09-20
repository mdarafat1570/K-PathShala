import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kpathshala/model/dashboard_page_model/dashboard_page_model.dart';

class ExamGraph extends StatelessWidget {
  final Exam exam;

  ExamGraph({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: exam.totalQuestionSet?.toDouble() ?? 0,
                  color: Colors.blue,
                  width: 20,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: exam.completedQuestionSet?.toDouble() ?? 0,
                  color: Colors.green,
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
