import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rádio')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Rádio — player integrado (mock).'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Play')),
          ],
        ),
      ),
    );
  }
}
