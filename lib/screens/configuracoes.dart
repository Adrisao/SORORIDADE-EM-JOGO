import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../app/progresso.dart';

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

  Future<void> _trocarSenha(BuildContext context) async {
    final email = Autenticacao.instancia.usuario?.email;
    if (email == null) return;

    String texto;
    Color cor;
    try {
      await Autenticacao.instancia.recuperarSenha(email);
      texto = 'Enviamos um link para $email. Confira sua caixa de entrada.';
      cor = Pallet.verdeAgua;
    } catch (e) {
      texto = Autenticacao.mensagemDeErro(e);
      cor = Pallet.rosaMagenta;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(backgroundColor: cor, content: Text(texto)));
  }

  // Excluir a conta: avisa, confirma a identidade e apaga tudo.
  Future<void> _excluirConta(BuildContext context) async {
    final auth = Autenticacao.instancia;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir sua conta?'),
        content: const Text(
          'Isso apaga para sempre o seu progresso, estrelas, gemas, XP, '
          'roupinhas e conquistas. Não dá para desfazer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Pallet.vermelhoCoral),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true || !context.mounted) return;

    // Quem tem senha digita a senha; quem entrou com Google escolhe a conta de novo.
    String? senha;
    if (auth.temSenha) {
      senha = await showDialog<String>(
        context: context,
        builder: (context) => const _PedirSenha(),
      );
      if (senha == null || !context.mounted) return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Pallet.rosaMagenta),
      ),
    );

    try {
      await auth.confirmarIdentidade(senha: senha);
      await auth.excluirConta();
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // fecha o carregando
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Pallet.rosaMagenta,
          content: Text(Autenticacao.mensagemDeErro(e)),
        ));
      return;
    }

    Progresso.instancia.limpar();
    PerfilAluna.instancia.limpar();
    if (!context.mounted) return;
    // Volta para o começo; como a conta não existe mais, abre o login.
    Navigator.of(context).popUntil((rota) => rota.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Pallet.roxoAmeixa,
      content: Text('Sua conta foi excluída.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final perfil = PerfilAluna.instancia;
    final auth = Autenticacao.instancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListenableBuilder(
        listenable: perfil,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _titulo('Jogo'),
            Card(
              child: SwitchListTile(
                secondary: Icon(
                  perfil.som ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: Pallet.rosaMagenta,
                ),
                title: const Text(
                  'Efeitos sonoros',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Sons de acerto e erro nas perguntas'),
                value: perfil.som,
                activeThumbColor: Pallet.rosaMagenta,
                onChanged: perfil.mudarSom,
              ),
            ),
            if (auth.disponivel && auth.usuario != null) ...[
              const SizedBox(height: 24),
              _titulo('Conta'),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_rounded, color: Pallet.rosaMagenta),
                      title: const Text('E-mail', style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(auth.usuario!.email ?? '—'),
                    ),
                    if (auth.temSenha) ...[
                      const Divider(height: 1, color: Pallet.lavanda),
                      ListTile(
                        leading: const Icon(Icons.lock_reset_rounded, color: Pallet.rosaMagenta),
                        title: const Text(
                          'Trocar senha',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text('Enviamos um link para o seu e-mail'),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Pallet.roxoLogo),
                        onTap: () => _trocarSenha(context),
                      ),
                    ],
                    const Divider(height: 1, color: Pallet.lavanda),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_forever_rounded,
                        color: Pallet.vermelhoCoral,
                      ),
                      title: const Text(
                        'Excluir conta',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Pallet.vermelhoCoral,
                        ),
                      ),
                      subtitle: const Text('Apaga a conta e todo o progresso'),
                      onTap: () => _excluirConta(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Pallet.roxoAmeixa,
        ),
      ),
    );
  }
}

// Pede a senha para confirmar a exclusão da conta.
class _PedirSenha extends StatefulWidget {
  const _PedirSenha();

  @override
  State<_PedirSenha> createState() => _PedirSenhaState();
}

class _PedirSenhaState extends State<_PedirSenha> {
  final _senha = TextEditingController();

  @override
  void dispose() {
    _senha.dispose();
    super.dispose();
  }

  void _confirmar() {
    if (_senha.text.isEmpty) return;
    Navigator.pop(context, _senha.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirme sua senha'),
      content: TextField(
        controller: _senha,
        obscureText: true,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Senha'),
        onSubmitted: (_) => _confirmar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Pallet.vermelhoCoral),
          onPressed: _confirmar,
          child: const Text('Excluir conta'),
        ),
      ],
    );
  }
}
