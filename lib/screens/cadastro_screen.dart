import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Único')),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (v) => name = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (v) => email = v ?? '',
                validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro salvo (mock)')));
                  }
                },
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
