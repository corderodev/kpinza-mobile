import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Métricas Generales:',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text(
              'Métrica 1: Valor',
              style: TextStyle(fontSize: 16),
            ),
            Padding(padding: EdgeInsets.all(6)),
            Text(
              'Métrica 2: Valor',
              style: TextStyle(fontSize: 16),
            ),
            Padding(padding: EdgeInsets.all(6)),
            Text(
              'Métrica 3: Valor',
              style: TextStyle(fontSize: 16),
            ),
            // ...
            SizedBox(height: 20),
            Padding(padding: EdgeInsets.all(20)),
            Text(
              'Métricas por proyecto:',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            ProjectMetricsList(),
          ],
        ),
      ),
    );
  }
}

class ProjectMetricsList extends StatelessWidget {
  const ProjectMetricsList({super.key});

  @override
  Widget build(BuildContext context) {
    final projectMetrics = [];

    if (projectMetrics.isEmpty) {
      return const Center(
        child: Text(
          'No hay métricas disponibles.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: projectMetrics.length,
      itemBuilder: (context, index) {
        final metric = projectMetrics[index];
        return ListTile(
          title: Text(metric.projectName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Métrica 1: ${metric.metric1}'),
              Text('Métrica 2: ${metric.metric2}'),
              Text('Métrica 3: ${metric.metric3}'),
            ],
          ),
        );
      },
    );
  }
}
