import 'package:flutter/material.dart';
import '../services/integration_service.dart';

class IAPanelScreen extends StatefulWidget {
  const IAPanelScreen({super.key});

  @override
  State<IAPanelScreen> createState() => _IAPanelScreenState();
}

class _IAPanelScreenState extends State<IAPanelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerCtr = TextEditingController();
  final _keyCtr = TextEditingController();
  final _tokenCtr = TextEditingController();
  Map<String, dynamic>? _keys;
  bool _loading = false;

  Future<void> _saveKey() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final provider = _providerCtr.text.trim();
    final key = _keyCtr.text.trim();
    final adminToken = _tokenCtr.text.trim();
    final ok = await IntegrationService.saveApiKey(provider, key, adminToken);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Chave salva para $provider' : 'Falha ao salvar')));
    if (ok) await _loadKeys();
  }

  Future<void> _loadKeys() async {
    setState(() => _loading = true);
    final adminToken = _tokenCtr.text.trim();
    try {
      final keys = await IntegrationService.getApiKeys(adminToken);
      setState(() {
        _keys = keys;
      });
    } catch (e) {
      setState(() {
        _keys = null;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _providerCtr.dispose();
    _keyCtr.dispose();
    _tokenCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de IAs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Configuração de chaves de API (servidor).', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Insira um ADMIN TOKEN (definido no backend) para listar e salvar chaves. Nunca coloque chaves diretamente no cliente em produção.'),
            const SizedBox(height: 12),
            TextFormField(controller: _tokenCtr, decoration: const InputDecoration(labelText: 'Admin Token (seu token)'),),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(controller: _providerCtr, decoration: const InputDecoration(labelText: 'Provider (ex: elevenlabs)'), validator: (v) => (v == null || v.isEmpty) ? 'Informe provider' : null,),
                const SizedBox(height: 8),
                TextFormField(controller: _keyCtr, decoration: const InputDecoration(labelText: 'API Key'), validator: (v) => (v == null || v.isEmpty) ? 'Informe chave' : null,),
                const SizedBox(height: 12),
                Row(children: [
                  ElevatedButton(onPressed: _loading ? null : _saveKey, child: const Text('Salvar chave (backend)')),
                  const SizedBox(width: 12),
                  OutlinedButton(onPressed: _loading ? null : _loadKeys, child: const Text('Listar chaves')),
                ])
              ]),
            ),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_keys != null) ...[
              const Divider(),
              const Text('Chaves armazenadas (somente visualização):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              for (final entry in _keys!.entries)
                ListTile(title: Text(entry.key), subtitle: Text(entry.value.toString())),
            ]
          ],
        ),
      ),
    );
  }
}
