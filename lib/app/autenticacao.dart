import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

// Login da aluna pelo Firebase Authentication:
// e-mail e senha, ou conta Google.
class Autenticacao {
  Autenticacao._();

  static final Autenticacao instancia = Autenticacao._();

  bool _disponivel = false;

  // false em plataformas sem Firebase (ex.: Linux desktop) e nos testes.
  // Nesse caso o app abre direto, sem login e sem salvar o progresso.
  bool get disponivel => _disponivel;

  // Conecta ao Firebase. Chamado uma vez, no main().
  Future<void> iniciar() async {
    try {
      final opcoes = DefaultFirebaseOptions.currentPlatform;
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: opcoes);
      }
      _disponivel = true;
    } on UnsupportedError catch (e) {
      debugPrint('Firebase não disponível nesta plataforma: $e');
    }
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get usuario => _disponivel ? _auth.currentUser : null;

  // Avisa sempre que a aluna entra ou sai.
  Stream<User?> get mudancas => _auth.authStateChanges();

  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> cadastrar(String nome, String email, String senha) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    await credencial.user?.updateDisplayName(nome.trim());
    // Recarrega para o nome já aparecer no perfil.
    await credencial.user?.reload();
  }

  Future<void> entrarComGoogle() async {
    final google = GoogleAuthProvider()..addScope('email');
    if (kIsWeb) {
      // No navegador abre uma janelinha (pop-up) do Google.
      await _auth.signInWithPopup(google);
    } else {
      // No Android abre a tela de escolha de conta do Google.
      await _auth.signInWithProvider(google);
    }
  }

  Future<void> recuperarSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  // Traduz os erros do Firebase para mensagens que a aluna entende.
  static String mensagemDeErro(Object erro) {
    if (erro is! FirebaseAuthException) {
      return 'Algo deu errado. Tente de novo.';
    }
    switch (erro.code) {
      case 'invalid-email':
        return 'Esse e-mail não parece válido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Já existe uma conta com esse e-mail. Tente entrar.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'account-exists-with-different-credential':
        return 'Esse e-mail já está cadastrado com outra forma de login.';
      case 'too-many-requests':
        return 'Muitas tentativas. Espere um pouco e tente de novo.';
      case 'network-request-failed':
        return 'Sem internet. Confira sua conexão.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
      case 'web-context-canceled':
      case 'canceled':
        return 'Login com Google cancelado.';
      case 'popup-blocked':
        return 'O navegador bloqueou a janela do Google. Permita pop-ups e tente de novo.';
      case 'operation-not-allowed':
        return 'Essa forma de login não está ativada no Firebase.';
      default:
        return 'Não foi possível entrar (${erro.code}).';
    }
  }
}
