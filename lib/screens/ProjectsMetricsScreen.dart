import 'package:flutter/material.dart';
import 'package:kpinza_mobile/components/PieChart.dart';

class ProjectMetricsScreen extends StatelessWidget {
  final String projectName;
  final int completedTasks;
  final int inProgressTasks;
  final int pendingTasks;
  final double eficacia;
  final double eficiencia;
  final double efectividad;

  const ProjectMetricsScreen({
    Key? key,
    required this.projectName,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.pendingTasks,
    required this.eficacia,
    required this.eficiencia,
    required this.efectividad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              _buildMetricRow(
                'Eficacia:',
                '${(eficacia * 100).toStringAsFixed(2)}%',
                Colors.green,
              ),
              _buildMetricRow(
                'Eficiencia:',
                '${(eficiencia * 100).toStringAsFixed(2)}%',
                Colors.orange,
              ),
              _buildMetricRow(
                'Efectividad:',
                '${(efectividad * 100).toStringAsFixed(2)}%',
                Colors.red,
              ),
              const SizedBox(height: 16),
              _buildMetricRow('Tareas Completadas:', completedTasks.toString()),
              _buildMetricRow(
                  'Tareas en Progreso:', inProgressTasks.toString()),
              _buildMetricRow('Tareas Pendientes:', pendingTasks.toString()),
              const SizedBox(height: 24),
              const Text(
                'Gráfico de Tareas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Completadas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'En Progreso',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pendientes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PieChartWidget(
                    completedTasks: completedTasks,
                    inProgressTasks: inProgressTasks,
                    pendingTasks: pendingTasks,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
