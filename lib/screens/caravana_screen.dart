import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class CaravanaScreen extends StatelessWidget {
  const CaravanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caravana IDM')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Caravana IDM — agenda de shows e logística (mock).'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Ver Roteiro')),
          ],
        ),
      ),
    );
  }
}
