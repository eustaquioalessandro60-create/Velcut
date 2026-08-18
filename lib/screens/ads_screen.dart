import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universal Ads')),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Integração com redes de anúncios (placeholder).'),
            SizedBox(height: 8),
            Text('Adapters e chaves devem ser configuradas para cada plataforma.'),
          ],
        ),
      ),
    );
  }
}
