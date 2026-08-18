import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Podcast')),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Podcast — lista de episódios (mock).'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Ver Episódios')),
          ],
        ),
      ),
    );
  }
}
