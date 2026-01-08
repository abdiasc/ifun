// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ECUBankingApp());
}

class ECUBankingApp extends StatelessWidget {
  const ECUBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECU Banking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ConnectionScreen(),
    const ReadECUScreen(),
    const ProgramECUScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.memory, color: Colors.white),
            SizedBox(width: 10),
            Text('ECU Banking System'),
          ],
        ),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bluetooth),
            selectedIcon: Icon(Icons.bluetooth_connected),
            label: 'Conectar',
          ),
          NavigationDestination(
            icon: Icon(Icons.download),
            selectedIcon: Icon(Icons.download_done),
            label: 'Leer ECU',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload),
            selectedIcon: Icon(Icons.upload_file),
            label: 'Programar',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history_toggle_off),
            label: 'Historial',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                _showQuickActions(context);
              },
              icon: const Icon(Icons.bolt),
              label: const Text('Acciones Rápidas'),
              backgroundColor: Colors.blueAccent,
            )
          : null,
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notificaciones'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Backup completado'),
              subtitle: Text('Hace 2 horas'),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('Actualización disponible'),
              subtitle: Text('Versión 2.2.0'),
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

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.dashboard, size: 18),
                  label: const Text('Diagnóstico Rápido'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.settings_backup_restore, size: 18),
                  label: const Text('Restaurar Default'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.delete_sweep, size: 18),
                  label: const Text('Borrar Códigos'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.speed, size: 18),
                  label: const Text('Datos en Vivo'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String _connectionStatus = 'Desconectado';
  bool _isScanning = false;
  String? _connectedDevice;
  List<String> _availableDevices = [];
  final List<String> _deviceTypes = ['OBD-II', 'J2534', 'K-TAG', 'KESS', 'MPPS'];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    // Simulación de carga de dispositivos guardados
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _availableDevices = [
          'OBD-II Scanner 001',
          'J2534 Passthru v2',
          'KESS V2 Clone',
          'K-TAG Master',
          'MPPS V18'
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta de estado de conexión
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _connectionStatus.contains('Conectado') ? 1.0 : 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _connectionStatus.contains('Conectado')
                                ? Colors.green
                                : Colors.blue,
                          ),
                          strokeWidth: 8,
                        ),
                      ),
                      Icon(
                        _connectionStatus.contains('Conectado')
                            ? Icons.link
                            : Icons.link_off,
                        size: 50,
                        color: _connectionStatus.contains('Conectado')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _connectionStatus,
                    style: TextStyle(
                      fontSize: 22,
                      color: _connectionStatus.contains('Conectado')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_connectedDevice != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _connectedDevice!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isScanning ? null : _startScan,
                        icon: Icon(
                          _isScanning ? Icons.search_off : Icons.search,
                        ),
                        label: Text(_isScanning ? 'Detener' : 'Escanear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isScanning ? Colors.orange : Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _connectionStatus.contains('Conectado')
                            ? _disconnect
                            : null,
                        icon: const Icon(Icons.power_settings_new),
                        label: const Text('Desconectar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tipos de dispositivos
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipos de Protocolos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _deviceTypes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(_deviceTypes[index]),
                            selected: false,
                            onSelected: (selected) {},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de dispositivos
          Expanded(
            child: Card(
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
                          'Dispositivos Disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _loadDevices,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _availableDevices.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.devices,
                                      size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No se encontraron dispositivos',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _startScan,
                                    child: const Text('Buscar dispositivos'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _availableDevices.length,
                              itemBuilder: (context, index) {
                                final device = _availableDevices[index];
                                final isConnected = _connectedDevice == device;
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
                                        color: isConnected
                                            ? Colors.green
                                            : Colors.blue,
                                      ),
                                    ),
                                    title: Text(device),
                                    subtitle: Text(
                                      'Protocolo: ${_getProtocolFromDevice(device)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isConnected)
                                          const Icon(Icons.check_circle,
                                              color: Colors.green),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () =>
                                              _connectToDevice(device),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isConnected
                                                ? Colors.grey
                                                : Colors.blueAccent,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(
                                            isConnected ? 'Conectado' : 'Conectar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getProtocolFromDevice(String device) {
    if (device.toLowerCase().contains('obd')) return 'OBD-II';
    if (device.toLowerCase().contains('j2534')) return 'J2534';
    if (device.toLowerCase().contains('kess')) return 'K-Line';
    if (device.toLowerCase().contains('k-tag')) return 'K-TAG';
    return 'CAN';
  }

  void _startScan() {
    if (_isScanning) {
      setState(() {
        _isScanning = false;
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _availableDevices.clear();
    });

    // Simulación de escaneo
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isScanning) {
        timer.cancel();
        return;
      }

      setState(() {
        final newDevices = [
          'OBD-II Scanner ${_availableDevices.length + 1}',
          'J2534 Device ${_availableDevices.length + 1}',
        ];
        _availableDevices.addAll(newDevices);
      });

      if (_availableDevices.length >= 8) {
        setState(() {
          _isScanning = false;
        });
        timer.cancel();
      }
    });
  }

  void _connectToDevice(String device) {
    setState(() {
      _connectedDevice = device;
      _connectionStatus = 'Conectado';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conectado a $device'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Simulación de verificación de conexión
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Conexión Exitosa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 16),
              Text(
                'Conectado exitosamente a:\n$device',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    });
  }

  void _disconnect() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desconectar'),
        content: const Text('¿Está seguro de que desea desconectar el dispositivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _connectionStatus = 'Desconectado';
                _connectedDevice = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispositivo desconectado'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Desconectar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

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

  final List<String> _vehicles = [
    'Toyota Corolla 2020',
    'Honda Civic 2019',
    'Ford F-150 2021',
    'Volkswagen Golf 2022'
  ];

  final List<String> _ecus = [
    'ECU Motor',
    'ECU Transmisión',
    'ECU ABS',
    'ECU Airbag',
    'ECU Clima'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
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
                  DropdownButtonFormField<String>(
                    value: _selectedVehicle,
                    decoration: const InputDecoration(
                      labelText: 'Vehículo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    items: _vehicles.map((vehicle) {
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
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedECU,
                    decoration: const InputDecoration(
                      labelText: 'ECU a Leer',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.memory),
                    ),
                    items: _ecus.map((ecu) {
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
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text('${(_progress * 100).toStringAsFixed(1)}%'),
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
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
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
                    Expanded(
                      child: _ecuData.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info, size: 64, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text('No hay datos leídos'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _ecuData.length,
                              itemBuilder: (context, index) {
                                final data = _ecuData[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  elevation: 1,
                                  child: ListTile(
                                    title: Text(data['parameter']),
                                    subtitle: Text(data['value']),
                                    trailing: Chip(
                                      label: Text(data['status']),
                                      backgroundColor: data['status'] == 'OK'
                                          ? Colors.green
                                          : Colors.red,
                                      labelStyle: const TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      data['status'] == 'OK'
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: data['status'] == 'OK'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
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
                  Container(
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
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _selectFile,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Seleccionar Archivo'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  Row(
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
                  ),
                  const SizedBox(height: 10),
                  if (_isProgramming)
                    const Text(
                      '¡NO APAGUE EL VEHÍCULO DURANTE LA PROGRAMACIÓN!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: Card(
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
            ),
          ),
        ],
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

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> history = [
      {
        'date': '2024-01-15 10:30',
        'vehicle': 'Toyota Corolla',
        'operation': 'Lectura ECU',
        'status': 'Completado',
        'color': Colors.green,
        'details': 'ECU Motor - Backup completo'
      },
      {
        'date': '2024-01-14 14:20',
        'vehicle': 'Honda Civic',
        'operation': 'Programación',
        'status': 'Completado',
        'color': Colors.green,
        'details': 'ECU Motor - Tuning Stage 1'
      },
      {
        'date': '2024-01-13 09:15',
        'vehicle': 'Ford F-150',
        'operation': 'Diagnóstico',
        'status': 'Fallido',
        'color': Colors.red,
        'details': 'Error de comunicación - Protocolo CAN'
      },
      {
        'date': '2024-01-12 16:45',
        'vehicle': 'Volkswagen Golf',
        'operation': 'Lectura ECU',
        'status': 'Completado',
        'color': Colors.green,
        'details': 'ECU Transmisión - Lectura parámetros'
      },
      {
        'date': '2024-01-11 11:20',
        'vehicle': 'BMW 320i',
        'operation': 'Programación',
        'status': 'Completado',
        'color': Colors.green,
        'details': 'ECU Motor - Actualización software'
      },
      {
        'date': '2024-01-10 08:45',
        'vehicle': 'Mercedes C200',
        'operation': 'Diagnóstico',
        'status': 'Completado',
        'color': Colors.green,
        'details': 'Scan completo - Sin errores'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial de Operaciones',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['color'],
                      child: Icon(
                        item['operation'] == 'Lectura ECU'
                            ? Icons.download
                            : item['operation'] == 'Programación'
                                ? Icons.upload
                                : Icons.dashboard,
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
                      backgroundColor: item['color'],
                    ),
                    onTap: () {
                      _showHistoryDetails(context, item);
                    },
                  ),
                );
              },
            ),
          ),
          Card(
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
                      Column(
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '${history.length}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Exitosas',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '${history.where((h) => h['status'] == 'Completado').length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Fallidas',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '${history.where((h) => h['status'] == 'Fallido').length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = false;
    bool notifications = true;
    bool autoConnect = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          const Text(
            'Preferencias',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (context, setState) {
              return Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Modo Oscuro'),
                      subtitle: const Text('Activar interfaz oscura'),
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Notificaciones'),
                      subtitle: const Text('Recibir notificaciones de estado'),
                      value: notifications,
                      onChanged: (value) {
                        setState(() {
                          notifications = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Conexión Automática'),
                      subtitle: const Text('Conectar automáticamente al último dispositivo'),
                      value: autoConnect,
                      onChanged: (value) {
                        setState(() {
                          autoConnect = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Dispositivo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Protocolo Predeterminado'),
                  subtitle: const Text('OBD-II'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Tiempo de Espera'),
                  subtitle: const Text('30 segundos'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.speed),
                  title: const Text('Velocidad de Puerto'),
                  subtitle: const Text('115200 baud'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Almacenamiento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.storage),
                  title: Text('Espacio Utilizado'),
                  subtitle: Text('1.2 GB de 16 GB'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Ruta de Archivos'),
                  subtitle: const Text('/sdcard/ECU_Backups'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Borrar Datos Temporales'),
                  subtitle: const Text('250 MB disponibles para borrar'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Seguridad',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Contraseña'),
                  subtitle: const Text('Configurar contraseña de acceso'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Huella Digital'),
                  subtitle: const Text('Activar autenticación biométrica'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Acerca de',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Versión'),
                  subtitle: Text('2.1.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Buscar Actualizaciones'),
                  subtitle: const Text('Última verificación: hoy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Ayuda y Soporte'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content: const Text('¿Está seguro de que desea cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}