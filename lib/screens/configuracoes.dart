import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';
import '../app/perfil_aluna.dart';

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
