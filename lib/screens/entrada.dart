import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';
import '../app/progresso.dart';
import 'home_page.dart';
import 'login.dart';

// "Porteiro" do app: sem aluna logada mostra o Login;
// com aluna logada carrega o progresso dela e abre a trilha.
class Entrada extends StatelessWidget {
  const Entrada({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Autenticacao.instancia;

    // Sem Firebase (Linux desktop, testes): abre direto, sem login.
    if (!auth.disponivel) return const HomePage();

    return StreamBuilder<User?>(
      stream: auth.mudancas,
      initialData: auth.usuario,
      builder: (context, snapshot) {
        final usuario = snapshot.data;
        // Contas anônimas (versões antigas do app) também vão para o login.
        if (usuario == null || usuario.isAnonymous) return const Login();
        // A key faz a trilha recomeçar do zero quando outra aluna entra.
        return _Logada(key: ValueKey(usuario.uid));
      },
    );
  }
}

class _Logada extends StatefulWidget {
  const _Logada({super.key});

  @override
  State<_Logada> createState() => _LogadaState();
}

class _LogadaState extends State<_Logada> {
  late final Future<void> _carregando = Progresso.instancia.carregar();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _carregando,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Pallet.rosaMagenta),
            ),
          );
        }
        return const HomePage();
      },
    );
  }
}
