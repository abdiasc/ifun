// ignore_for_file: library_private_types_in_public_api, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/material.dart';

class ProgramECUScreen extends StatefulWidget {
  const ProgramECUScreen({super.key});

  @override
  _ProgramECUScreenState createState() => _ProgramECUScreenState();
}

class _ProgramECUScreenState extends State<ProgramECUScreen> {
  String? _selectedFile;
  bool _isProgramming = false;
  double _progress = 0.0;
  String _programmingStatus = 'Listo';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgrammingCard(),
            const SizedBox(height: 20),
            _buildInstructionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammingCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.upload_file, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Programar ECU',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildFileSelector(),
            const SizedBox(height: 20),
            _buildProgressSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 10),
            if (_isProgramming) _buildWarningText(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.insert_drive_file, size: 48, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            _selectedFile ?? 'No hay archivo seleccionado',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _selectFile,
            icon: const Icon(Icons.folder_open),
            label: const Text('Seleccionar Archivo'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        const SizedBox(height: 10),
        Text('${(_progress * 100).toStringAsFixed(1)}%'),
        const SizedBox(height: 10),
        Text(
          _programmingStatus,
          style: TextStyle(
            color: _isProgramming ? Colors.orange : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _selectedFile != null && !_isProgramming
                ? _startProgramming
                : null,
            icon: const Icon(Icons.upload),
            label: const Text('Programar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isProgramming ? _cancelProgramming : null,
            icon: const Icon(Icons.cancel),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningText() {
    return const Text(
      '¡NO APAGUE EL VEHÍCULO DURANTE LA PROGRAMACIÓN!',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInstructionsCard() {
    return const Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instrucciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.battery_charging_full),
              title: Text('Asegúrese de que el vehículo tenga batería cargada'),
            ),
            ListTile(
              leading: Icon(Icons.power),
              title: Text('Mantenga el motor APAGADO pero la llave en ON'),
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('No interrumpa la programación bajo ninguna circunstancia'),
            ),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Haga siempre un backup antes de programar'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectFile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Archivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('ECU_Backup_2024_01_15.bin'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedFile = 'ECU_Backup_2024_01_15.bin';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('ECU_Tuning_Stage1.bin'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedFile = 'ECU_Tuning_Stage1.bin';
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('ECU_Original.bin'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedFile = 'ECU_Original.bin';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startProgramming() async {
    setState(() {
      _isProgramming = true;
      _progress = 0.0;
      _programmingStatus = 'Iniciando...';
    });

    // Simulación de programación
    for (int i = 0; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (_isProgramming) {
        setState(() {
          _progress = i / 20;
          if (i < 5) _programmingStatus = 'Verificando...';
          else if (i < 10) _programmingStatus = 'Borrando memoria...';
          else if (i < 15) _programmingStatus = 'Escribiendo...';
          else _programmingStatus = 'Verificando escritura...';
        });
      }
    }

    if (_isProgramming) {
      setState(() {
        _isProgramming = false;
        _programmingStatus = 'Programación exitosa!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Programación completada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _cancelProgramming() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Programación'),
        content: const Text('¿Está seguro de que desea cancelar la programación? Esto podría dejar la ECU en estado inconsistente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isProgramming = false;
                _programmingStatus = 'Cancelado';
              });
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}