
import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> deviceTypes = [
    'OBD-II',
    'J2534',
    'K-TAG',
    'KESS',
    'MPPS'
  ];

  static const List<String> sampleDevices = [
    'OBD-II Scanner 001',
    'J2534 Passthru v2',
    'KESS V2 Clone',
    'K-TAG Master',
    'MPPS V18'
  ];

  static const List<String> vehicleList = [
    'Toyota Corolla 2020',
    'Honda Civic 2019',
    'Ford F-150 2021',
    'Volkswagen Golf 2022'
  ];

  static const List<String> ecuList = [
    'ECU Motor',
    'ECU Transmisión',
    'ECU ABS',
    'ECU Airbag',
    'ECU Clima'
  ];

  static const List<Map<String, dynamic>> sampleHistory = [
    {
      'date': '2024-01-15 10:30',
      'vehicle': 'Toyota Corolla',
      'operation': 'Lectura ECU',
      'status': 'Completado',
      'color': 'green',
      'details': 'ECU Motor - Backup completo'
    },
    {
      'date': '2024-01-14 14:20',
      'vehicle': 'Honda Civic',
      'operation': 'Programación',
      'status': 'Completado',
      'color': 'green',
      'details': 'ECU Motor - Tuning Stage 1'
    },
    {
      'date': '2024-01-13 09:15',
      'vehicle': 'Ford F-150',
      'operation': 'Diagnóstico',
      'status': 'Fallido',
      'color': 'red',
      'details': 'Error de comunicación - Protocolo CAN'
    },
    {
      'date': '2024-01-12 16:45',
      'vehicle': 'Volkswagen Golf',
      'operation': 'Lectura ECU',
      'status': 'Completado',
      'color': 'green',
      'details': 'ECU Transmisión - Lectura parámetros'
    },
    {
      'date': '2024-01-11 11:20',
      'vehicle': 'BMW 320i',
      'operation': 'Programación',
      'status': 'Completado',
      'color': 'green',
      'details': 'ECU Motor - Actualización software'
    },
    {
      'date': '2024-01-10 08:45',
      'vehicle': 'Mercedes C200',
      'operation': 'Diagnóstico',
      'status': 'Completado',
      'color': 'green',
      'details': 'Scan completo - Sin errores'
    },
  ];

  static Color getStatusColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}