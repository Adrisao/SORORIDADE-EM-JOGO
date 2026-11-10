import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/progresso.dart';

// Explica o projeto e como funcionam estrelas, gemas e medalhas.
class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    final primeira3 = Progresso.gemasPor(3, primeiraVez: true);
    final repetir3 = Progresso.gemasPor(3, primeiraVez: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o projeto')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Pallet.roxoLogo,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.diversity_1_rounded, color: Pallet.branco, size: 48),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sororidade em Jogo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Pallet.roxoAmeixa,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Projeto Empodera Digital',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Pallet.roxoLogo, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _bloco(
            Icons.favorite_rounded,
            'O que é',
            'Uma trilha de lições curtas, com textos, vídeos e jogos, para meninas '
                'aprenderem sobre sororidade, empatia, respeito e cooperação.',
          ),
          _bloco(
            Icons.star_rounded,
            'Estrelas',
            'Cada lição vale até 3 estrelas: 3 se você não errar, 2 com até 2 erros '
                'e 1 com mais erros. Vale sempre a sua melhor tentativa.',
          ),
          _bloco(
            Icons.diamond_rounded,
            'Gemas',
            'Cada lição concluída dá 5 gemas por estrela. Na primeira vez que você '
                'conclui uma lição, ganha 10 gemas de bônus (até $primeira3 gemas). '
                'Repetindo a lição, você ganha até $repetir3. Use as gemas na loja '
                'de roupinhas!',
          ),
          _bloco(
            Icons.military_tech_rounded,
            'Medalhas',
            'Algumas atitudes rendem medalhas. Toque numa medalha do perfil para '
                'ver como ganhá-la.',
          ),
          _bloco(
            Icons.local_fire_department_rounded,
            'Dias seguidos',
            'Faça pelo menos uma lição por dia para manter a sua sequência acesa.',
          ),
        ],
      ),
    );
  }

  Widget _bloco(IconData icone, String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icone, color: Pallet.rosaMagenta, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Pallet.roxoAmeixa,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(texto, style: const TextStyle(fontSize: 15, height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
