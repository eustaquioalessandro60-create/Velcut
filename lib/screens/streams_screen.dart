import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class StreamsScreen extends StatelessWidget {
  const StreamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IDM Streams')),
      drawer: const MainDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Streams e Loja (mock)', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, child: const Text('Abrir Loja IDM')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: const Text('Integrar Mercado Livre (mock)')),
            ],
          ),
        ),
      ),
    );
  }
}
