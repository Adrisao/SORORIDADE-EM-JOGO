import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../app/progresso.dart';
import '../data/missoes.dart';
import '../widgets/avatar.dart';
import '../widgets/comum.dart';

// Tela de missões: a aluna cumpre tarefas e resgata gemas e XP.
class Missoes extends StatelessWidget {
  const Missoes({super.key});

  @override
  Widget build(BuildContext context) {
    final progresso = Progresso.instancia;
    final perfil = PerfilAluna.instancia;

    return ListenableBuilder(
      listenable: Listenable.merge([progresso, perfil]),
      builder: (context, _) {
        final diarias = missoes.where((m) => m.diaria).toList();
        final especiais = missoes.where((m) => !m.diaria).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Missões'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SaldoDeGemas(gemas: perfil.gemas),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _nivel(perfil),
              _titulo(
                'Missões de hoje',
                'Recomeçam todo dia à meia-noite',
                Icons.today_rounded,
              ),
              for (final m in diarias) _CartaoMissao(missao: m),
              _titulo(
                'Missões especiais',
                'Cada uma só pode ser resgatada uma vez',
                Icons.workspace_premium_rounded,
              ),
              for (final m in especiais) _CartaoMissao(missao: m),
            ],
          ),
        );
      },
    );
  }

  // Faixa do topo com o nível e a barra de XP
  Widget _nivel(PerfilAluna perfil) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: const BoxDecoration(
        color: Pallet.roxoAmeixa,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Pallet.dourado,
              shape: BoxShape.circle,
              border: Border.all(color: Pallet.amareloSol, width: 4),
            ),
            child: Text(
              '${perfil.nivel}',
              style: const TextStyle(
                color: Pallet.branco,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nível ${perfil.nivel}',
                  style: const TextStyle(
                    color: Pallet.branco,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: perfil.xpNoNivel / PerfilAluna.xpPorNivel,
                    minHeight: 10,
                    backgroundColor: Pallet.roxoLogo,
                    color: Pallet.amareloSol,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${perfil.xpNoNivel} / ${PerfilAluna.xpPorNivel} XP '
                  'para o nível ${perfil.nivel + 1}  ·  ${perfil.xp} XP no total',
                  style: const TextStyle(color: Pallet.lavanda, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titulo(String texto, String subtitulo, IconData icone) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        children: [
          Icon(icone, color: Pallet.rosaMagenta),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  texto,
                  style: const TextStyle(
                    color: Pallet.roxoAmeixa,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Pallet.roxoLogo, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoMissao extends StatelessWidget {
  final Missao missao;

  const _CartaoMissao({required this.missao});

  @override
  Widget build(BuildContext context) {
    final progresso = Progresso.instancia;
    final perfil = PerfilAluna.instancia;

    final feito = missao.feito(progresso, perfil);
    final cumprida = missao.cumprida(progresso, perfil);
    final resgatada = missao.resgatada(perfil);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Card(
        color: resgatada ? Pallet.lavanda : Pallet.branco,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: resgatada
                      ? Pallet.verdeAgua
                      : (cumprida ? Pallet.rosaMagenta : Pallet.lavanda),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  resgatada ? Icons.check_rounded : missao.icone,
                  color: resgatada || cumprida
                      ? Pallet.branco
                      : Pallet.roxoLogo,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      missao.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: feito / missao.meta,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$feito/${missao.meta}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Pallet.roxoAmeixa,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Se faltar espaço, o botão desce para a linha de baixo
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Pilula(
                          texto: '+${missao.gemas}',
                          icone: Icons.diamond_rounded,
                          fundo: Pallet.azulCeu.withValues(alpha: 0.25),
                          cor: Pallet.gema,
                        ),
                        Pilula(
                          texto: '+${missao.xp} XP',
                          icone: Icons.trending_up_rounded,
                          fundo: Pallet.amareloSol.withValues(alpha: 0.3),
                          cor: Pallet.roxoAmeixa,
                        ),
                        _botao(context, cumprida, resgatada),
                      ],
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

  Widget _botao(BuildContext context, bool cumprida, bool resgatada) {
    if (resgatada) {
      return const Text(
        'Feito!',
        style: TextStyle(color: Pallet.verdeAgua, fontWeight: FontWeight.w700),
      );
    }

    return ElevatedButton(
      onPressed: cumprida ? () => _resgatar(context) : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        textStyle: const TextStyle(
          fontFamily: Pallet.fonte,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: const Text('Resgatar'),
    );
  }

  void _resgatar(BuildContext context) {
    final perfil = PerfilAluna.instancia;
    final nivelAntes = perfil.nivel;

    final ok = perfil.resgatarMissao(
      missao.id,
      diaria: missao.diaria,
      gemas: missao.gemas,
      xp: missao.xp,
    );
    if (!ok) return;

    final subiu = perfil.nivel > nivelAntes;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Pallet.roxoAmeixa,
          content: Text(
            subiu
                ? 'Você subiu para o nível ${perfil.nivel}! '
                      '+${missao.gemas} gemas e +${missao.xp} XP'
                : 'Missão resgatada! +${missao.gemas} gemas e +${missao.xp} XP',
          ),
        ),
      );
  }
}
