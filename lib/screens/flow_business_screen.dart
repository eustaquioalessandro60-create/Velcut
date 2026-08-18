import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class FlowBusinessScreen extends StatelessWidget {
  const FlowBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flow Business')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Flow Business — ferramentas para gestão de negócios (mock).'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Abrir Dashboard')),
          ],
        ),
      ),
    );
  }
}
