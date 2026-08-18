import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IDM Cifras')),
      drawer: const MainDrawer(),
      body: ResponsiveLayout(
        mobile: _HomeMobile(),
        desktop: _HomeDesktop(),
      ),
    );
  }
}

class _HomeMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Text('Bem-vindo ao Ecossistema Zuri Rimane', style: TextStyle(fontSize: 22)),
            SizedBox(height: 12),
            Text('Use o menu para navegar entre os módulos.'),
          ],
        ),
      ),
    );
  }
}

class _HomeDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('IDM Cifras — Ecossistema Zuri Rimane', style: TextStyle(fontSize: 28)),
                  SizedBox(height: 8),
                  Text('Plataforma integrada para músicos, fãs e negócios.'),
                ],
              ),
            ),
            Expanded(
              child: Image.network('https://via.placeholder.com/400x250.png?text=IDM+Cifras', fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
