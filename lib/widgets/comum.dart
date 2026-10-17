
import 'package:flutter/material.dart';
import '../app/pallet.dart';

// Pequenos widgets e funções usados em mais de uma tela.

// "Lição 1 — O que é sororidade?" -> "O que é sororidade?"
String tituloCurto(String titulo) {
  final partes = titulo.split('—');
  return partes.length > 1 ? partes.last.trim() : titulo;
}

IconData iconeDoTipo(String? tipo) {
  switch (tipo) {
    case 'video':
      return Icons.play_circle_fill_rounded;
    case 'jogo':
      return Icons.sports_esports_rounded;
    default:
      return Icons.menu_book_rounded;
  }
}

String nomeDoTipo(String? tipo) {
  switch (tipo) {
    case 'video':
      return 'VÍDEO';
    case 'jogo':
      return 'JOGO';
    default:
      return 'TEXTO';
  }
}

// Pílula no estilo do "POR QUE BAIXAR?"
class Pilula extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final Color fundo;
  final Color cor;

  const Pilula({
    super.key,
    required this.texto,
    this.icone,
    this.fundo = Pallet.verdeAguaClaro,
    this.cor = Pallet.roxoAmeixa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 16, color: cor),
            const SizedBox(width: 6),
          ],
          Text(
            texto,
            style: TextStyle(
              color: cor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// Linha de 3 estrelas (preenchidas conforme a pontuação)
class Estrelas extends StatelessWidget {
  final int quantidade;
  final double tamanho;

  const Estrelas({
    super.key,
    required this.quantidade,
    this.tamanho = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Icon(
          i < quantidade ? Icons.star_rounded : Icons.star_outline_rounded,
          size: tamanho,
          color: i < quantidade ? Pallet.rosaMagenta : Pallet.roxoLogo,
        );
      }),
    );
  }
}
