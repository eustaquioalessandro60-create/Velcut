import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class FaclubeScreen extends StatelessWidget {
  const FaclubeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fã Clube')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Fã Clube — criação de grupos e benefícios (mock).'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Criar Fã Clube')),
          ],
        ),
      ),
    );
  }
}
