import 'package:flutter/material.dart';

import '../app/perfil_aluna.dart';
import '../app/progresso.dart';
import 'quizzes.dart';

// Missões (quests): a aluna cumpre a tarefa e resgata gemas e XP.
// As diárias recomeçam todo dia; as especiais só podem ser resgatadas uma vez.
class Missao {
  final String id;
  final String titulo;
  final IconData icone;
  final bool diaria;
  final int meta;
  final int gemas;
  final int xp;
  final int Function(Progresso progresso, PerfilAluna perfil) andamento;

  const Missao({
    required this.id,
    required this.titulo,
    required this.icone,
    required this.diaria,
    required this.meta,
    required this.gemas,
    required this.xp,
    required this.andamento,
  });

  // Quanto já foi feito, sem passar da meta.
  int feito(Progresso p, PerfilAluna perfil) =>
      andamento(p, perfil).clamp(0, meta);

  bool cumprida(Progresso p, PerfilAluna perfil) => feito(p, perfil) >= meta;

  bool resgatada(PerfilAluna perfil) => perfil.resgatou(id, diaria: diaria);

  bool podeResgatar(Progresso p, PerfilAluna perfil) =>
      cumprida(p, perfil) && !resgatada(perfil);
}

final List<Missao> missoes = [
  // Diárias
  Missao(
    id: 'diaria_uma_licao',
    titulo: 'Faça 1 lição hoje',
    icone: Icons.menu_book_rounded,
    diaria: true,
    meta: 1,
    gemas: 10,
    xp: 20,
    andamento: (p, _) => p.licoesHoje,
  ),
  Missao(
    id: 'diaria_tres_licoes',
    titulo: 'Faça 3 lições hoje',
    icone: Icons.library_books_rounded,
    diaria: true,
    meta: 3,
    gemas: 20,
    xp: 50,
    andamento: (p, _) => p.licoesHoje,
  ),
  Missao(
    id: 'diaria_perfeita',
    titulo: 'Termine uma lição sem errar hoje',
    icone: Icons.bolt_rounded,
    diaria: true,
    meta: 1,
    gemas: 15,
    xp: 30,
    andamento: (p, _) => p.licoesPerfeitasHoje,
  ),

  // Especiais
  Missao(
    id: 'tres_licoes',
    titulo: 'Conclua 3 lições da trilha',
    icone: Icons.route_rounded,
    diaria: false,
    meta: 3,
    gemas: 30,
    xp: 60,
    andamento: (p, _) => p.totalConcluidas,
  ),
  Missao(
    id: 'dez_estrelas',
    titulo: 'Junte 10 estrelas',
    icone: Icons.star_rounded,
    diaria: false,
    meta: 10,
    gemas: 25,
    xp: 50,
    andamento: (p, _) => p.totalEstrelas,
  ),
  Missao(
    id: 'tres_dias',
    titulo: 'Estude 3 dias seguidos',
    icone: Icons.local_fire_department_rounded,
    diaria: false,
    meta: 3,
    gemas: 30,
    xp: 60,
    andamento: (p, _) => p.diasSeguidos,
  ),
  Missao(
    id: 'primeira_roupinha',
    titulo: 'Compre uma roupinha na loja',
    icone: Icons.checkroom_rounded,
    diaria: false,
    meta: 1,
    gemas: 10,
    xp: 20,
    andamento: (_, perfil) => perfil.totalCompradas,
  ),
  Missao(
    id: 'trilha_completa',
    titulo: 'Conclua a trilha inteira',
    icone: Icons.emoji_events_rounded,
    diaria: false,
    meta: quizzes.length,
    gemas: 100,
    xp: 200,
    andamento: (p, _) => p.totalConcluidas,
  ),
];

// Quantas missões estão prontas para resgatar (para o aviso na barra de baixo).
int missoesParaResgatar(Progresso p, PerfilAluna perfil) =>
    missoes.where((m) => m.podeResgatar(p, perfil)).length;
