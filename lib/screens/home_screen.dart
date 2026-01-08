// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'connection_screen.dart';
import 'read_ecu_screen.dart';
import 'program_ecu_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_app_bar.dart';

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
      appBar: CustomAppBar(
        title: 'ECU Banking System',
        showNotifications: true,
        onNotificationsPressed: () => _showNotifications(context),
        onSettingsPressed: () => _navigateToSettings(context),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton(context) : null,
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
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
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickActions(context),
      icon: const Icon(Icons.bolt),
      label: const Text(''),
      backgroundColor: Colors.blueAccent,
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

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
