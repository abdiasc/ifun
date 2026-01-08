// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/device_card.dart';
import '../utils/constants.dart';

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

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConnectionStatusCard(),
            const SizedBox(height: 20),
            _buildProtocolTypesCard(),
            const SizedBox(height: 20),
            _buildDevicesListCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    return Card(
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
                  icon: Icon(_isScanning ? Icons.search_off : Icons.search),
                  label: Text(_isScanning ? 'Detener' : 'Escanear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning ? Colors.orange : Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _connectionStatus.contains('Conectado') ? _disconnect : null,
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Desconectar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolTypesCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipos de Protocolos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.deviceTypes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(AppConstants.deviceTypes[index]),
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
    );
  }

  Widget _buildDevicesListCard() {
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
                  'Dispositivos Disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadDevices,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _availableDevices.isEmpty
                ? _buildEmptyState()
                : _buildDevicesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.devices, size: 64, color: Colors.grey),
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
      ),
    );
  }

  Widget _buildDevicesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableDevices.length,
      itemBuilder: (context, index) {
        final device = _availableDevices[index];
        return DeviceCard(
          deviceName: device,
          protocol: _getProtocolFromDevice(device),
          isConnected: _connectedDevice == device,
          onConnect: () => _connectToDevice(device),
        );
      },
    );
  }

  void _loadDevices() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _availableDevices = AppConstants.sampleDevices;
      });
    });
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
      setState(() => _isScanning = false);
      return;
    }

    setState(() {
      _isScanning = true;
      _availableDevices.clear();
    });

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
        setState(() => _isScanning = false);
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