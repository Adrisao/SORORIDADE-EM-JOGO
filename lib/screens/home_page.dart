
import 'dart:math';

import 'package:flutter/material.dart';
import '../app/buttons.dart';
import '../app/pallet.dart';
import '../app/progresso.dart';
import '../data/quizzes.dart';
import '../widgets/comum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final progresso = Progresso.instancia;

  @override
  Widget build(BuildContext context) {
    // Redesenha a trilha sempre que o progresso muda
    return ListenableBuilder(
      listenable: progresso,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sororidade em Jogo'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Pallet.branco),
                    const SizedBox(width: 4),
                    Text(
                      '${progresso.totalEstrelas}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              _boasVindas(),
              const SizedBox(height: 32),
              for (var i = 0; i < quizzes.length; i++) _itemDaTrilha(i),
            ],
          ),
        );
      },
    );
  }

  // Faixa "Bem-vinda" no topo com o progresso da trilha
  Widget _boasVindas() {
    final total = quizzes.length;
    final feitas = progresso.totalConcluidas;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: const BoxDecoration(
        color: Pallet.roxoAmeixa,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Pallet.roxoLogo,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.diversity_1_rounded,
              color: Pallet.branco,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vinda à trilha!',
                  style: TextStyle(
                    color: Pallet.branco,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Aprenda sobre sororidade, empatia e respeito.',
                  style: TextStyle(color: Pallet.lavanda, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : feitas / total,
                    minHeight: 10,
                    backgroundColor: Pallet.roxoLogo,
                  ),
                ),
                const SizedBox(height: 10),
                Pilula(texto: '$feitas DE $total LIÇÕES'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Cada lição fica deslocada para um lado, formando um caminho em zigue-zague
  Widget _itemDaTrilha(int indice) {
    final deslocamento = sin(indice * pi / 2) * 70;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Transform.translate(
        offset: Offset(deslocamento, 0),
        child: Center(
          child: Buttons(licao: quizzes[indice]),
        ),
      ),
    );
  }
}
