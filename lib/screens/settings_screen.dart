import 'package:flutter/material.dart';
import 'package:ifun/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoConnect = true;

  @override
  void initState() {
    super.initState();
    // Inicializar según el tema actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _darkMode = Theme.of(context).brightness == Brightness.dark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Apariencia', currentTheme),
              _buildAppearanceCard(isDarkMode),
              const SizedBox(height: 20),
              _buildSectionTitle('Preferencias', currentTheme),
              _buildPreferencesCard(currentTheme),
              const SizedBox(height: 20),
              _buildSectionTitle('Dispositivo', currentTheme),
              _buildDeviceCard(currentTheme),
              const SizedBox(height: 20),
              _buildSectionTitle('Almacenamiento', currentTheme),
              _buildStorageCard(currentTheme),
              const SizedBox(height: 20),
              _buildSectionTitle('Seguridad', currentTheme),
              _buildSecurityCard(currentTheme),
              const SizedBox(height: 20),
              _buildSectionTitle('Acerca de', currentTheme),
              _buildAboutCard(currentTheme),
              const SizedBox(height: 30),
              _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildAppearanceCard(bool isDarkMode) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: Theme.of(context).cardTheme.elevation,
      shape: Theme.of(context).cardTheme.shape,
      child: SwitchListTile(
        title: Text(
          'Modo Oscuro',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        subtitle: Text(
          isDarkMode ? 'Tema oscuro activado' : 'Tema claro activado',
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
        value: _darkMode,
        // En el onChanged del SwitchListTile de Modo Oscuro:
        onChanged: (value) {
          final themeProvider = Provider.of<ThemeProvider>(
            context,
            listen: false,
          );
          themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          setState(() {
            _darkMode = value;
          });
        },
      ),
    );
  }

  Widget _buildPreferencesCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              'Notificaciones',
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            subtitle: Text(
              'Recibir notificaciones de estado',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          Divider(height: 1, color: theme.dividerColor),
          SwitchListTile(
            title: Text(
              'Conexión Automática',
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            subtitle: Text(
              'Conectar automáticamente al último dispositivo',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            value: _autoConnect,
            onChanged: (value) => setState(() => _autoConnect = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          _buildSettingsTile(
            Icons.language,
            'Protocolo Predeterminado',
            'OBD-II',
            theme,
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.timer,
            'Tiempo de Espera',
            '30 segundos',
            theme,
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.speed,
            'Velocidad de Puerto',
            '115200 baud',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.storage, color: theme.iconTheme.color),
            title: Text(
              'Espacio Utilizado',
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            subtitle: Text(
              '1.2 GB de 16 GB',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.folder,
            'Ruta de Archivos',
            '/sdcard/ECU_Backups',
            theme,
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.delete,
            'Borrar Datos Temporales',
            '250 MB disponibles para borrar',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          _buildSettingsTile(
            Icons.security,
            'Contraseña',
            'Configurar contraseña de acceso',
            theme,
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.fingerprint,
            'Huella Digital',
            'Activar autenticación biométrica',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeData theme) {
    return Card(
      color: theme.cardTheme.color,
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info, color: theme.iconTheme.color),
            title: Text(
              'Versión',
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            subtitle: Text(
              '2.1.0',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(
            Icons.update,
            'Buscar Actualizaciones',
            'Última verificación: hoy',
            theme,
          ),
          Divider(height: 1, color: theme.dividerColor),
          _buildSettingsTile(Icons.help, 'Ayuda y Soporte', '', theme),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    ThemeData theme,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            )
          : null,
      trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: _showLogoutDialog,
      icon: const Icon(Icons.logout),
      label: const Text('Cerrar Sesión'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  void _showLogoutDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardTheme.color,
        shape: theme.cardTheme.shape,
        title: Text(
          'Cerrar Sesión',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
        content: Text(
          '¿Está seguro de que desea cerrar sesión?',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
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
  }
}
