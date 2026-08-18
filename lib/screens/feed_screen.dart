import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/navigation_drawer.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<String> _items = [];
  bool _isLoading = false;
  int _page = 0;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200 && !_isLoading) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final more = List.generate(10, (i) => 'Post #${_page * 10 + i + 1} - Conteúdo exemplo');
    setState(() {
      _items.addAll(more);
      _page++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Infinito')),
      drawer: const MainDrawer(),
      body: ListView.builder(
        controller: _controller,
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _isLoading ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ) : const SizedBox.shrink();
          }
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.music_note)),
              title: Text(item),
              subtitle: const Text('Descrição breve do post...'),
            ),
          );
        },
      ),
    );
  }
}
