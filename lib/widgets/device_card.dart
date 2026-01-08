// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String protocol;
  final bool isConnected;
  final VoidCallback onConnect;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.protocol,
    required this.isConnected,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isConnected
                ? Colors.green.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.memory,
            color: isConnected ? Colors.green : Colors.blue,
          ),
        ),
        title: Text(deviceName),
        subtitle: Text(
          'Protocolo: $protocol',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnected)
              const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.grey : Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(isConnected ? 'Conectado' : 'Conectar'),
            ),
          ],
        ),
      ),
    );
  }
}