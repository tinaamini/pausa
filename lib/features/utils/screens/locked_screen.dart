import 'package:flutter/material.dart';
import 'package:pausa/core/router/rout_name.dart';
import 'package:pausa/core/router/router.dart';

class LockScreen extends StatelessWidget {
  final String appName;

  const LockScreen({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$appName is blocked",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                router.go(RouteName.home);
              },
              child: const Text('برگشت'),
            ),
          ],
        ),
      ),
    );
  }
}