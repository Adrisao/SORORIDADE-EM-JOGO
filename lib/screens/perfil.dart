
import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/progresso.dart';

// Tela de perfil da aluna.

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  // Medalhas de exemplo
  static const List<Map<String, dynamic>> conquistas = [
    {'titulo': 'Primeira lição', 'icone': Icons.menu_book_rounded, 'ganhou': true},
    {'titulo': 'Amiga empática', 'icone': Icons.favorite_rounded, 'ganhou': true},
    {'titulo': 'Respeito total', 'icone': Icons.handshake_rounded, 'ganhou': false},
    {'titulo': 'Boa de diálogo', 'icone': Icons.forum_rounded, 'ganhou': false},
    {'titulo': 'Mente rápida', 'icone': Icons.bolt_rounded, 'ganhou': false},
    {'titulo': 'Juntas mais fortes', 'icone': Icons.emoji_events_rounded, 'ganhou': false},
  ];

  @override
  Widget build(BuildContext context) {
    final progresso = Progresso.instancia;
    final medalhas = conquistas.where((c) => c['ganhou'] == true).length;

    // Atualiza as estatísticas sempre que o progresso muda
    return ListenableBuilder(
      listenable: progresso,
      builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _cabecalho(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _titulo('Estatísticas'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _estatistica(Icons.star_rounded, '${progresso.totalEstrelas}',
                        'Estrelas', Pallet.rosaMagenta),
                    const SizedBox(width: 12),
                    _estatistica(Icons.menu_book_rounded,
                        '${progresso.totalConcluidas}', 'Lições feitas', Pallet.verdeAgua),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _estatistica(Icons.local_fire_department_rounded, '3',
                        'Dias seguidos', Pallet.rosaMagenta),
                    const SizedBox(width: 12),
                    _estatistica(Icons.military_tech_rounded, '$medalhas',
                        'Medalhas', Pallet.roxoLogo),
                  ],
                ),
                const SizedBox(height: 28),
                _titulo('Conquistas'),
                const SizedBox(height: 12),
                _conquistas(),
                const SizedBox(height: 28),
                _opcoes(context),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  // Aviso para o que ainda não foi implementado
  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          backgroundColor: Pallet.roxoAmeixa,
          content: Text('Em breve!'),
        ),
      );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Pallet.roxoAmeixa,
      ),
    );
  }

  // Avatar, nome e turma
  Widget _cabecalho(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: const BoxDecoration(
        color: Pallet.roxoAmeixa,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Pallet.roxoLogo,
              shape: BoxShape.circle,
              border: Border.all(color: Pallet.rosaMagenta, width: 4),
            ),
            child: const Icon(Icons.face_3_rounded, size: 56, color: Pallet.branco),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aluna',
            style: TextStyle(
              color: Pallet.branco,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '5º ano A',
            style: TextStyle(color: Pallet.lavanda, fontSize: 15),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Pallet.branco,
              side: const BorderSide(color: Pallet.branco, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => _emBreve(context),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Editar perfil'),
          ),
        ],
      ),
    );
  }

  Widget _estatistica(IconData icone, String valor, String rotulo, Color cor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icone, color: cor, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valor,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Pallet.roxoAmeixa,
                      ),
                    ),
                    Text(
                      rotulo,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Grade de medalhas: as não conquistadas aparecem com cadeado
  Widget _conquistas() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 20,
          children: [
            for (final conquista in conquistas)
              SizedBox(
                width: 96,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: conquista['ganhou'] ? Pallet.rosaMagenta : Pallet.lavanda,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        conquista['ganhou']
                            ? conquista['icone'] as IconData
                            : Icons.lock_rounded,
                        color: conquista['ganhou'] ? Pallet.branco : Pallet.roxoLogo,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      conquista['titulo'].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: conquista['ganhou'] ? Pallet.roxoAmeixa : Pallet.roxoLogo,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _opcoes(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _opcao(Icons.settings_rounded, 'Configurações', () => _emBreve(context)),
          const Divider(height: 1, color: Pallet.lavanda),
          _opcao(Icons.info_rounded, 'Sobre o projeto', () => _emBreve(context)),
          const Divider(height: 1, color: Pallet.lavanda),
          _opcao(Icons.logout_rounded, 'Sair', () => _emBreve(context)),
        ],
      ),
    );
  }

  Widget _opcao(IconData icone, String texto, VoidCallback aoTocar) {
    return ListTile(
      leading: Icon(icone, color: Pallet.rosaMagenta),
      title: Text(texto, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Pallet.roxoLogo),
      onTap: aoTocar,
    );
  }
}
