import 'package:flutter/material.dart';

class ECUDataTile extends StatelessWidget {
  final String parameter;
  final String value;
  final String status;

  const ECUDataTile({
    super.key,
    required this.parameter,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        title: Text(parameter),
        subtitle: Text(value),
        trailing: Chip(
          label: Text(
            status,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: status == 'OK' ? Colors.green : Colors.red,
        ),
        leading: Icon(
          status == 'OK' ? Icons.check_circle : Icons.error,
          color: status == 'OK' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}