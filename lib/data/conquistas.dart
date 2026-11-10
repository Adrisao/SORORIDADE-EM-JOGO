import 'package:flutter/material.dart';

import '../app/perfil_aluna.dart';
import '../app/progresso.dart';
import 'quizzes.dart';

// Medalhas do perfil. Cada uma diz como é ganha.
class Conquista {
  final String titulo;
  final String comoGanhar;
  final IconData icone;
  final bool Function(Progresso progresso, PerfilAluna perfil) ganhou;

  const Conquista({
    required this.titulo,
    required this.comoGanhar,
    required this.icone,
    required this.ganhou,
  });
}

final List<Conquista> conquistas = [
  Conquista(
    titulo: 'Primeira lição',
    comoGanhar: 'Conclua a sua primeira lição.',
    icone: Icons.menu_book_rounded,
    ganhou: (p, _) => p.totalConcluidas >= 1,
  ),
  Conquista(
    titulo: 'Amiga empática',
    comoGanhar: 'Conclua a lição "Entendendo a empatia".',
    icone: Icons.favorite_rounded,
    ganhou: (p, _) => p.concluida(2),
  ),
  Conquista(
    titulo: 'Respeito total',
    comoGanhar: 'Conclua a lição "Respeitando as diferenças".',
    icone: Icons.handshake_rounded,
    ganhou: (p, _) => p.concluida(3),
  ),
  Conquista(
    titulo: 'Boa de diálogo',
    comoGanhar: 'Conclua a lição "Resolvendo conflitos com diálogo".',
    icone: Icons.forum_rounded,
    ganhou: (p, _) => p.concluida(5),
  ),
  Conquista(
    titulo: 'Mente rápida',
    comoGanhar: 'Tire 3 estrelas em uma lição, sem errar nada.',
    icone: Icons.bolt_rounded,
    ganhou: (p, _) => quizzes.any((q) => p.estrelasDa(q['numero'] as int) == 3),
  ),
  Conquista(
    titulo: 'Constância',
    comoGanhar: 'Estude 3 dias seguidos.',
    icone: Icons.local_fire_department_rounded,
    ganhou: (p, _) => p.diasSeguidos >= 3,
  ),
  Conquista(
    titulo: 'Estilosa',
    comoGanhar: 'Compre a sua primeira roupinha na loja.',
    icone: Icons.checkroom_rounded,
    ganhou: (_, perfil) => perfil.totalCompradas >= 1,
  ),
  Conquista(
    titulo: 'Juntas mais fortes',
    comoGanhar: 'Conclua a missão final da trilha.',
    icone: Icons.emoji_events_rounded,
    ganhou: (p, _) => p.concluida(7),
  ),
];
