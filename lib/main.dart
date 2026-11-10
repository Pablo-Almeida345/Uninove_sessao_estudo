import 'package:flutter/material.dart';

void main() {
  runApp(const SessaoApp());
}

class SessaoApp extends StatelessWidget {
  const SessaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicio(),
    );
  }
}

class SessaoEstudo {
  final String tema;
  final int minutos;
  final String observacao;

  const SessaoEstudo({
    required this.tema,
    required this.minutos,
    required this.observacao,
  });
}

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  SessaoEstudo? _ultimaSessao;

  String resumoSessao() {
    final sessao = _ultimaSessao;
    if (sessao == null) {
      return 'Nenhuma sessão confirmada.';
    }
    final observacao = sessao.observacao.isEmpty
        ? 'Sem observação'
        : sessao.observacao;
    return 'Tema: ${sessao.tema}\n'
        'Duração: ${sessao.minutos} minutos\n'
        'Observação: $observacao';
  }


  Future<void> abrirFormulario() async {
    final resultado = await Navigator.push<SessaoEstudo>(
      context,
      MaterialPageRoute<SessaoEstudo>(
        builder: (context) => const TelaFormulario(),
      ),
    );
    if (!mounted || resultado == null) {
      return;
    }
    setState(() {
      _ultimaSessao = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas sessões')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.menu_book, size: 64, color: Colors.indigo),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(resumoSessao()),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: abrirFormulario,
                child: const Text('Nova sessão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _temaController = TextEditingController();
  final _minutosController = TextEditingController();
  final _observacaoController = TextEditingController();

  @override
  void dispose() {
    _temaController.dispose();
    _minutosController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }


  void confirmar() {
    final valido = _formKey.currentState?.validate() ?? false;
    if (!valido) {
      return;
    }
    final minutos = int.tryParse(_minutosController.text.trim());
    if (minutos == null) {
      return;
    }
    final sessao = SessaoEstudo(
      tema: _temaController.text.trim(),
      minutos: minutos,
      observacao: _observacaoController.text.trim(),
    );
    Navigator.pop<SessaoEstudo>(context, sessao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova sessão')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Planeje uma sessão de estudo.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _temaController,
                  validator: (value) {
                    final tema = (value ?? '').trim();
                    if (tema.isEmpty) {
                      return 'Informe o tema do estudo.';
                    }
                    if (tema.length < 3) {
                      return 'Use pelo menos 3 caracteres no tema.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tema do estudo',
                    hintText: 'Ex.: Revisar Form e validação',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _minutosController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final texto = (value ?? '').trim();
                    if (texto.isEmpty) {
                      return 'Informe a duração.';
                    }
                    final minutos = int.tryParse(texto);
                    if (minutos == null) {
                      return 'Digite um número inteiro de minutos.';
                    }
                    if (minutos < 1 || minutos > 240) {
                      return 'Use uma duração de 1 a 240 minutos.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Duração em minutos',
                    hintText: 'De 1 a 240',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observação (opcional)',
                    hintText: 'Ex.: Resolver os exemplos da aula',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: confirmar,
                  child: const Text('Confirmar sessão'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
