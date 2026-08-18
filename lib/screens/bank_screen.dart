import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Invest')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bank Invest — protótipo (mock)'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Ver investimentos')),
          ],
        ),
      ),
    );
  }
}
