// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // ignore: prefer_final_fields
  bool _bluetoothEnabled = true;

  DiscoveredDevice? _connectedDevice;
  final List<DiscoveredDevice> _availableDevices = [];
  final Map<String, int> _deviceSignalStrength = {};

  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  final FlutterReactiveBle _ble = FlutterReactiveBle();

  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;
  static const String _lastDeviceKey = 'last_ble_device';

  @override
  void initState() {
    super.initState();
    _ble.connectedDeviceStream.listen(_handleConnectionStateChange);
    _tryAutoReconnect();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  // ===================== CONNECTION STATE =====================

  void _handleConnectionStateChange(ConnectionStateUpdate state) {
    if (!mounted) return;

    DiscoveredDevice? device;
    try {
      device = _availableDevices.firstWhere(
        (d) => d.id == state.deviceId,
      );
    } catch (_) {
      device = null;
    }

    setState(() {
      _connectionState = state.connectionState;

      if (state.connectionState == DeviceConnectionState.connected) {
        _connectionStatus = 'Conectado';
        _connectedDevice = device;
        _saveLastDevice(state.deviceId);
      } else if (state.connectionState == DeviceConnectionState.connecting) {
        _connectionStatus = 'Conectando...';
      } else {
        _connectionStatus = 'Desconectado';
        _connectedDevice = null;
      }
    });
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBluetoothStatusCard(),
          const SizedBox(height: 20),
          _buildConnectionStatusCard(),
          const SizedBox(height: 20),
          _buildProtocolTypesCard(),
          const SizedBox(height: 20),
          _buildDevicesListCard(),
        ],
      ),
    );
  }

  Widget _buildBluetoothStatusCard() {
    return Card(
      elevation: 3,
      color: _bluetoothEnabled ? Colors.green[50] : Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _bluetoothEnabled
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              color: _bluetoothEnabled ? Colors.green : Colors.red,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _bluetoothEnabled
                        ? 'Bluetooth Activado'
                        : 'Bluetooth Desactivado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _bluetoothEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                  const Text(
                    'Listo para escanear dispositivos',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    final connected = _connectionState == DeviceConnectionState.connected;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: connected ? 1 : null,
                    strokeWidth: 8,
                  ),
                ),
                Icon(
                  connected ? Icons.link : Icons.link_off,
                  size: 50,
                  color: connected ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _connectionStatus,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: connected ? Colors.green : Colors.red,
              ),
            ),
            if (_connectedDevice != null) ...[
              const SizedBox(height: 8),
              Text(
                _connectedDevice!.name.isNotEmpty
                    ? _connectedDevice!.name
                    : _connectedDevice!.id,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? _stopScan : _startScan,
                  icon: Icon(_isScanning ? Icons.stop : Icons.search),
                  label: Text(_isScanning ? 'Detener' : 'Escanear'),
                ),
                ElevatedButton.icon(
                  onPressed: connected ? _disconnect : null,
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Desconectar'),
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
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          children: AppConstants.deviceTypes
              .map((e) => Chip(label: Text(e)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDevicesListCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _availableDevices.isEmpty
            ? const Center(
                child: Text('No se encontraron dispositivos'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _availableDevices.length,
                itemBuilder: (_, index) {
                  final device = _availableDevices[index];
                  return DeviceCard(
                    deviceName:
                        device.name.isNotEmpty ? device.name : device.id,
                    macAddress: device.id,
                    protocol: _getProtocolFromDevice(device.name),
                    signalStrength: device.rssi,
                    isConnected: _connectedDevice?.id == device.id,
                    onConnect: () => _connectToDevice(device),
                  );
                },
              ),
      ),
    );
  }

  // ===================== BLE =====================

  Future<void> _startScan() async {
    final ok = await _requestPermissions();
    if (!ok) return;

    setState(() {
      _isScanning = true;
      _availableDevices.clear();
      _deviceSignalStrength.clear();
    });

    _scanSubscription = _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (_availableDevices.every((d) => d.id != device.id)) {
        setState(() {
          _availableDevices.add(device);
        });
      }
    });

    await Future.delayed(const Duration(seconds: 5));
    _stopScan();
  }

  Future<void> _stopScan() async {
    await _scanSubscription?.cancel();
    setState(() => _isScanning = false);
  }

  Future<void> _connectToDevice(DiscoveredDevice device) async {
    await _scanSubscription?.cancel(); // 🔴 MUY IMPORTANTE
    _scanSubscription = null;

    setState(() {
      _isScanning = false;
      _connectionStatus = 'Conectando...';
    });

    _connectionSubscription?.cancel();
    _connectionSubscription = _ble
        .connectToDevice(
      id: device.id,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen(
      _handleConnectionStateChange,
      onError: (error) {
        setState(() {
          _connectionStatus = 'Error de conexión';
        });
      },
    );
  }

  Future<void> _disconnect() async {
    await _connectionSubscription?.cancel();
    setState(() {
      _connectedDevice = null;
      _connectionState = DeviceConnectionState.disconnected;
      _connectionStatus = 'Desconectado';
    });
  }

  Future<void> _saveLastDevice(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDeviceKey, deviceId);
  }

  Future<void> _tryAutoReconnect() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDeviceId = prefs.getString(_lastDeviceKey);

    if (lastDeviceId == null) return;

    setState(() {
      _connectionStatus = 'Reconectando...';
    });

    _connectionSubscription = _ble
        .connectToDevice(
      id: lastDeviceId,
      connectionTimeout: const Duration(seconds: 10),
    )
        .listen(_handleConnectionStateChange, onError: (_) {
      setState(() {
        _connectionStatus = 'Desconectado';
      });
    });
  }

  // ===================== HELPERS =====================

  Future<bool> _requestPermissions() async {
    final permissions = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return permissions.values.every((p) => p.isGranted);
  }

  String _getProtocolFromDevice(String name) {
    final d = name.toLowerCase();
    if (d.contains('obd')) return 'OBD-II';
    if (d.contains('elm')) return 'OBD-II';
    if (d.contains('can')) return 'CAN';
    return 'BLE';
  }
}
