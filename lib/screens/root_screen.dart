import 'package:flutter/material.dart';
import 'enhancement_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luck Forge')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EnhancementScreen())),
          child: const Text('Open Enhancement'),
        ),
      ),
    );
  }
}
