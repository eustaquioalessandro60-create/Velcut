import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Legal')),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Registro Legal: Gestão de direitos autorais e documentação (mock).'),
            SizedBox(height: 8),
            Text('Integre cartórios e serviços legais conforme necessário.'),
          ],
        ),
      ),
    );
  }
}
