import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kpinza_mobile/utils/app_colors.dart';

class PieChartWidget extends StatelessWidget {
  final int completedTasks;
  final int inProgressTasks;
  final int pendingTasks;

  const PieChartWidget({
    Key? key,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.pendingTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: showingSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 77, 197, 47),
        value: completedTasks.toDouble(),
        title: completedTasks.toString(),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: AppColors.chart2,
        value: inProgressTasks.toDouble(),
        title: inProgressTasks.toString(),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: AppColors.chart3,
        value: pendingTasks.toDouble(),
        title: pendingTasks.toString(),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }
}
