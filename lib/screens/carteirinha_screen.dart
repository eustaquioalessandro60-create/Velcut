import 'package:flutter/material.dart';
import '../services/pdf_service.dart';
import '../widgets/navigation_drawer.dart';

class CarteirinhaScreen extends StatelessWidget {
  const CarteirinhaScreen({super.key});

  Future<void> _exportPdf(BuildContext context) async {
    final data = {
      'name': 'João da Silva',
      'id': 'IDM-001234',
      'protocol': DateTime.now().millisecondsSinceEpoch.toString()
    };
    final bytes = await PdfService.generateCarteirinhaPdf(data);
    await PdfService.sharePdf(bytes, 'carteirinha_${data['id']}.pdf');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF gerado e compartilhado')));
  }

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
            ElevatedButton(onPressed: () {}, child: const Text('Visualizar Carteirinha (preview)')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => _exportPdf(context), child: const Text('Exportar Carteirinha (PDF)')),
          ],
        ),
      ),
    );
  }
}
