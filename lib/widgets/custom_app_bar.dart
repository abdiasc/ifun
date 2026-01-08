import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotifications;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onSettingsPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showNotifications = false,
    this.onNotificationsPressed,
    this.onSettingsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.memory, color: Colors.white),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      actions: [
        if (showNotifications && onNotificationsPressed != null)
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: onNotificationsPressed,
          ),
        if (onSettingsPressed != null)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: onSettingsPressed,
          ),
      ],
    );
  }
}