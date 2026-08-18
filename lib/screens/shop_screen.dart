import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loja / Mercado Livre')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Loja integrada (mock)'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Ver produtos')),
          ],
        ),
      ),
    );
  }
}
