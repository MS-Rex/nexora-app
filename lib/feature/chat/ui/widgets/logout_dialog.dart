import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color.fromARGB(255, 124, 58, 237)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onLogout();
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Color.fromARGB(255, 124, 58, 237)),
          ),
        ),
      ],
    );
  }

  static void show(BuildContext context, VoidCallback onLogout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(onLogout: onLogout);
      },
    );
  }
}
