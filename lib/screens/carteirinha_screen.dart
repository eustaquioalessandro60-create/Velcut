import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class CarteirinhaScreen extends StatelessWidget {
  const CarteirinhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carteirinha de Músico')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            const Text('Nome do Músico'),
            const SizedBox(height: 6),
            const Text('IDM-000123'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Exportar Carteirinha (PDF)')),
          ],
        ),
      ),
    );
  }
}
