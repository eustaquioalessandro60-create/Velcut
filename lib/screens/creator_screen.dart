import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/responsive.dart';
import '../services/pdf_service.dart';
import '../services/integration_service.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  String _title = 'Vídeo Exemplo';
  String _script = 'Este é um roteiro de exemplo para geração de vídeo.';
  bool _isGenerating = false;
  String _selectedProvider = 'runway';
  final _adminTokenCtr = TextEditingController();

  Future<void> _generateAllFormats() async {
    setState(() => _isGenerating = true);
    final formats = ['YouTube 16:9', 'TikTok 9:16', 'Instagram 1:1', 'Instagram Reels 9:16', 'Facebook 16:9', 'Kwai 9:16'];
    final previewData = {'title': _title, 'protocol': DateTime.now().millisecondsSinceEpoch.toString()};

    try {
      // Create a job on the backend to orchestrate chosen provider
      final job = await IntegrationService.createJob(_selectedProvider, 'create_video', {
        'title': _title,
        'script': _script,
        'formats': formats,
      }, _adminTokenCtr.text.trim());

      // Backend returns job id and maybe a zip url for the generated mock PDFs/videos
      if (job.containsKey('zipUrl')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job enviado. Baixando ZIP...')));
        // In a full implementation, open the URL or download
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job criado (mock). Verifique backend.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao criar job: $e')));
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  void dispose() {
    _adminTokenCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Máquina de Criação')),
      drawer: const MainDrawer(),
      body: ResponsiveLayout(
        mobile: _buildMobile(),
        desktop: _buildDesktop(),
      ),
    );
  }

  Widget _buildMobile() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(child: _previewArea()),
          _controls(),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: _previewArea()),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _controls()),
        ],
      ),
    );
  }

  Widget _previewArea() {
    return Container(
      color: const Color(0xFF08101A),
      child: Column(
        children: [
          Expanded(child: Center(child: Text(_title, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 20)))),
          SizedBox(height: 120, child: ListView(scrollDirection: Axis.horizontal, children: List.generate(6, (i) => Padding(padding: const EdgeInsets.all(8.0), child: Container(width: 160, color: Colors.black54, child: Center(child: Text('Preview ${i + 1}'))))))
        ],
      ),
    );
  }

  Widget _controls() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: TextEditingController(text: _title), decoration: const InputDecoration(labelText: 'Título'), onChanged: (v) => _title = v),
          const SizedBox(height: 8),
          TextField(maxLines: 6, controller: TextEditingController(text: _script), decoration: const InputDecoration(labelText: 'Roteiro / Texto'), onChanged: (v) => _script = v),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: _selectedProvider, items: const [
            DropdownMenuItem(value: 'elevenlabs', child: Text('ElevenLabs (TTS)'),),
            DropdownMenuItem(value: 'openai', child: Text('OpenAI TTS / Whisper'),),
            DropdownMenuItem(value: 'runway', child: Text('Runway (vídeo)'),),
            DropdownMenuItem(value: 'kling', child: Text('Kling (vídeo)'),),
            DropdownMenuItem(value: 'pika', child: Text('Pika (vídeo)'),),
            DropdownMenuItem(value: 'sora', child: Text('Sora (avatar)'),),
            DropdownMenuItem(value: 'invideo', child: Text('InVideo'),),
          ], onChanged: (v) => setState(() => _selectedProvider = v ?? _selectedProvider)),
          const SizedBox(height: 8),
          TextField(controller: _adminTokenCtr, decoration: const InputDecoration(labelText: 'Admin Token (backend)'),),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: _isGenerating ? null : _generateAllFormats, icon: const Icon(Icons.cloud_download), label: Text(_isGenerating ? 'Gerando...' : 'Gerar 6 formatos e baixar')),
          const SizedBox(height: 8),
          const Text('Observação: esta demo cria jobs no backend usando a IA selecionada. Forneça chaves via Painel de IAs.'),
        ],
      ),
    );
  }
}
