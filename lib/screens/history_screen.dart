import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Operaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildHistoryList(),
            const SizedBox(height: 20),
            _buildStatisticsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppConstants.sampleHistory.length,
      itemBuilder: (context, index) {
        final item = AppConstants.sampleHistory[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppConstants.getStatusColor(item['color']),
              child: Icon(
                _getOperationIcon(item['operation']),
                color: Colors.white,
              ),
            ),
            title: Text(item['vehicle']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item['date']} - ${item['operation']}'),
                Text(
                  item['details'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(
                item['status'],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: AppConstants.getStatusColor(item['color']),
            ),
            onTap: () => _showHistoryDetails(context, item),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard() {
    final completed = AppConstants.sampleHistory
        .where((h) => h['status'] == 'Completado')
        .length;
    final failed = AppConstants.sampleHistory
        .where((h) => h['status'] == 'Fallido')
        .length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', '${AppConstants.sampleHistory.length}'),
                _buildStatItem('Exitosas', '$completed', Colors.green),
                _buildStatItem('Fallidas', '$failed', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  IconData _getOperationIcon(String operation) {
    switch (operation) {
      case 'Lectura ECU':
        return Icons.download;
      case 'Programación':
        return Icons.upload;
      default:
        return Icons.dashboard;
    }
  }

  void _showHistoryDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles: ${item['vehicle']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operación: ${item['operation']}'),
            Text('Fecha: ${item['date']}'),
            Text('Estado: ${item['status']}'),
            Text('Detalles: ${item['details']}'),
            const SizedBox(height: 20),
            const Text(
              'Acciones:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('Repetir'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}