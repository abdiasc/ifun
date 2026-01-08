// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/ecu_data_tile.dart';

class ReadECUScreen extends StatefulWidget {
  const ReadECUScreen({super.key});

  @override
  _ReadECUScreenState createState() => _ReadECUScreenState();
}

class _ReadECUScreenState extends State<ReadECUScreen> {
  String? _selectedVehicle;
  String? _selectedECU;
  double _progress = 0.0;
  bool _isReading = false;
  List<Map<String, dynamic>> _ecuData = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReadCard(),
            const SizedBox(height: 20),
            _buildDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Leer ECU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildVehicleDropdown(),
            const SizedBox(height: 16),
            _buildECUDropdown(),
            const SizedBox(height: 20),
            CustomProgressIndicator(
              progress: _progress,
              color: Colors.blue,
              label: _isReading ? 'Leyendo ECU...' : 'Listo',
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _selectedVehicle != null && _selectedECU != null && !_isReading
                  ? _startReading
                  : null,
              icon: const Icon(Icons.download),
              label: Text(_isReading ? 'Leyendo...' : 'Iniciar Lectura'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedVehicle,
      decoration: const InputDecoration(
        labelText: 'Vehículo',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.directions_car),
      ),
      items: AppConstants.vehicleList.map((vehicle) {
        return DropdownMenuItem(
          value: vehicle,
          child: Text(vehicle),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedVehicle = value;
        });
      },
    );
  }

  Widget _buildECUDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedECU,
      decoration: const InputDecoration(
        labelText: 'ECU a Leer',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.memory),
      ),
      items: AppConstants.ecuList.map((ecu) {
        return DropdownMenuItem(
          value: ecu,
          child: Text(ecu),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedECU = value;
        });
      },
    );
  }

  Widget _buildDataCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Datos Leídos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_ecuData.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.save_alt),
                    onPressed: _exportData,
                    tooltip: 'Exportar datos',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _ecuData.isEmpty
                ? _buildEmptyState()
                : _buildDataList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 64, color: Colors.grey),
            SizedBox(height: 10),
            Text('No hay datos leídos'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _ecuData.length,
      itemBuilder: (context, index) {
        final data = _ecuData[index];
        return ECUDataTile(
          parameter: data['parameter'],
          value: data['value'],
          status: data['status'],
        );
      },
    );
  }

  void _startReading() async {
    setState(() {
      _isReading = true;
      _progress = 0.0;
      _ecuData.clear();
    });

    // Simulación de lectura
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _progress = i / 10;
      });
    }

    // Datos de ejemplo
    setState(() {
      _ecuData = [
        {'parameter': 'Código de ECU', 'value': '7E8', 'status': 'OK'},
        {'parameter': 'VIN', 'value': '1HGCM82633A123456', 'status': 'OK'},
        {'parameter': 'Número de Parte', 'value': '37820-PND-A01', 'status': 'OK'},
        {'parameter': 'Versión Software', 'value': 'v2.1.5', 'status': 'OK'},
        {'parameter': 'Kilometraje', 'value': '45,230 km', 'status': 'OK'},
      ];
      _isReading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lectura completada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Datos'),
        content: const Text('Seleccione el formato de exportación:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Datos exportados en formato BIN'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('BIN'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Datos exportados en formato HEX'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('HEX'),
          ),
        ],
      ),
    );
  }
}