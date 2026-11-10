import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../app/progresso.dart';
import '../data/conquistas.dart';
import '../widgets/avatar.dart';
import 'configuracoes.dart';
import 'editar_perfil.dart';
import 'loja.dart';
import 'sobre.dart';

// Tela de perfil da aluna.

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    final progresso = Progresso.instancia;
    final perfil = PerfilAluna.instancia;

    // Atualiza as estatísticas sempre que o progresso ou o perfil muda
    return ListenableBuilder(
      listenable: Listenable.merge([progresso, perfil]),
      builder: (context, _) {
        final ganhas = conquistas.where((c) => c.ganhou(progresso, perfil)).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
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
                        _estatistica(Icons.local_fire_department_rounded,
                            '${progresso.diasSeguidos}', 'Dias seguidos', Pallet.rosaMagenta),
                        const SizedBox(width: 12),
                        _estatistica(Icons.diamond_rounded, '${perfil.gemas}', 'Gemas',
                            Pallet.gema),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _titulo('Conquistas ($ganhas de ${conquistas.length})'),
                    const SizedBox(height: 12),
                    _conquistas(context, progresso, perfil),
                    const SizedBox(height: 28),
                    _opcoes(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  // Pergunta antes de sair, para não sair sem querer.
  Future<void> _sair(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text('Seu progresso fica salvo. É só entrar de novo para continuar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;
    await Autenticacao.instancia.sair();
    Progresso.instancia.limpar();
    PerfilAluna.instancia.limpar();
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

  // Avatar, nome e e-mail
  Widget _cabecalho(BuildContext context) {
    final botao = OutlinedButton.styleFrom(
      foregroundColor: Pallet.branco,
      side: const BorderSide(color: Pallet.branco, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: const BoxDecoration(
        color: Pallet.roxoAmeixa,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _abrir(context, const Loja()),
            child: const AvatarDaAluna(tamanho: 110, borda: Pallet.rosaMagenta),
          ),
          const SizedBox(height: 12),
          // Nome e e-mail da conta logada (atualiza se o nome mudar).
          StreamBuilder<User?>(
            stream: Autenticacao.instancia.disponivel
                ? FirebaseAuth.instance.userChanges()
                : const Stream.empty(),
            initialData: Autenticacao.instancia.usuario,
            builder: (context, snapshot) {
              final usuario = snapshot.data;
              final nome = usuario?.displayName;
              return Column(
                children: [
                  Text(
                    (nome == null || nome.isEmpty) ? 'Aluna' : nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Pallet.branco,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (usuario?.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      usuario!.email!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Pallet.lavanda, fontSize: 15),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                style: botao,
                onPressed: () => _abrir(context, const EditarPerfil()),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('Editar perfil'),
              ),
              OutlinedButton.icon(
                style: botao,
                onPressed: () => _abrir(context, const Loja()),
                icon: const Icon(Icons.checkroom_rounded, size: 18),
                label: const Text('Loja'),
              ),
            ],
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

  // Grade de medalhas: as não conquistadas aparecem com cadeado.
  // Tocar numa medalha mostra como ganhá-la.
  Widget _conquistas(BuildContext context, Progresso progresso, PerfilAluna perfil) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 20,
          children: [
            for (final conquista in conquistas)
              _medalha(context, conquista, conquista.ganhou(progresso, perfil)),
          ],
        ),
      ),
    );
  }

  Widget _medalha(BuildContext context, Conquista conquista, bool ganhou) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            backgroundColor: ganhou ? Pallet.verdeAgua : Pallet.roxoAmeixa,
            content: Text(
              ganhou
                  ? '${conquista.titulo}: conquistada!'
                  : '${conquista.titulo}: ${conquista.comoGanhar}',
            ),
          ));
      },
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ganhou ? Pallet.rosaMagenta : Pallet.lavanda,
                shape: BoxShape.circle,
              ),
              child: Icon(
                ganhou ? conquista.icone : Icons.lock_rounded,
                color: ganhou ? Pallet.branco : Pallet.roxoLogo,
                size: 30,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              conquista.titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ganhou ? Pallet.roxoAmeixa : Pallet.roxoLogo,
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
          _opcao(Icons.checkroom_rounded, 'Loja de roupinhas',
              () => _abrir(context, const Loja())),
          const Divider(height: 1, color: Pallet.lavanda),
          _opcao(Icons.settings_rounded, 'Configurações',
              () => _abrir(context, const Configuracoes())),
          const Divider(height: 1, color: Pallet.lavanda),
          _opcao(Icons.info_rounded, 'Sobre o projeto', () => _abrir(context, const Sobre())),
          // Sem Firebase (Linux desktop) não há conta para sair.
          if (Autenticacao.instancia.disponivel) ...[
            const Divider(height: 1, color: Pallet.lavanda),
            _opcao(Icons.logout_rounded, 'Sair', () => _sair(context)),
          ],
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
