import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';

// Tela de entrada: login por e-mail e senha, cadastro e login com Google.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  bool cadastrando = false; // false = "Entrar", true = "Criar conta"
  bool carregando = false;
  bool senhaVisivel = false;
  String? erro;

  final auth = Autenticacao.instancia;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  // Roda uma ação de login mostrando o carregamento e o erro, se houver.
  // Quando dá certo, o porteiro (Entrada) troca a tela sozinho.
  Future<void> _executar(Future<void> Function() acao) async {
    setState(() {
      carregando = true;
      erro = null;
    });
    try {
      await acao();
    } catch (e) {
      if (mounted) setState(() => erro = Autenticacao.mensagemDeErro(e));
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  void _enviar() {
    if (!_form.currentState!.validate()) return;
    _executar(() => cadastrando
        ? auth.cadastrar(_nome.text, _email.text, _senha.text)
        : auth.entrar(_email.text, _senha.text));
  }

  Future<void> _esqueciSenha() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      setState(() => erro = 'Digite seu e-mail acima para recuperar a senha.');
      return;
    }
    await _executar(() => auth.recuperarSenha(email));
    if (mounted && erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Pallet.roxoAmeixa,
          content: Text('Enviamos um link para $email. Confira sua caixa de entrada.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _cabecalho(),
                  const SizedBox(height: 28),
                  _formulario(),
                  const SizedBox(height: 20),
                  _divisor(),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: carregando
                        ? null
                        : () => _executar(auth.entrarComGoogle),
                    icon: const Text(
                      'G',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    label: const Text('Entrar com Google'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: carregando
                        ? null
                        : () => setState(() {
                              cadastrando = !cadastrando;
                              erro = null;
                            }),
                    style: TextButton.styleFrom(foregroundColor: Pallet.verdeAgua),
                    child: Text(
                      cadastrando
                          ? 'Já tenho conta. Entrar'
                          : 'Ainda não tenho conta. Criar conta',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Pallet.roxoLogo,
            shape: BoxShape.circle,
            border: Border.all(color: Pallet.rosaMagenta, width: 4),
          ),
          child: const Icon(Icons.diversity_1_rounded, size: 48, color: Pallet.branco),
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
        const SizedBox(height: 6),
        Text(
          cadastrando ? 'Crie sua conta para salvar seu progresso' : 'Entre para continuar sua trilha',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _formulario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (cadastrando) ...[
                  TextFormField(
                    controller: _nome,
                    enabled: !carregando,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    decoration: _decoracao('Seu nome', Icons.face_3_rounded),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Digite seu nome' : null,
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _email,
                  enabled: !carregando,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: _decoracao('E-mail', Icons.mail_rounded),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Digite um e-mail válido'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _senha,
                  enabled: !carregando,
                  obscureText: !senhaVisivel,
                  textInputAction: TextInputAction.done,
                  autofillHints: [
                    cadastrando ? AutofillHints.newPassword : AutofillHints.password,
                  ],
                  onFieldSubmitted: (_) => _enviar(),
                  decoration: _decoracao('Senha', Icons.lock_rounded).copyWith(
                    suffixIcon: IconButton(
                      tooltip: senhaVisivel ? 'Esconder senha' : 'Mostrar senha',
                      icon: Icon(
                        senhaVisivel ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Pallet.roxoLogo,
                      ),
                      onPressed: () => setState(() => senhaVisivel = !senhaVisivel),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6)
                      ? 'A senha precisa ter pelo menos 6 caracteres'
                      : null,
                ),
                if (!cadastrando)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: carregando ? null : _esqueciSenha,
                      style: TextButton.styleFrom(foregroundColor: Pallet.verdeAgua),
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 14),
                if (erro != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Pallet.lavanda,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_rounded, color: Pallet.rosaMagenta),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            erro!,
                            style: const TextStyle(
                              color: Pallet.roxoAmeixa,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                ElevatedButton(
                  onPressed: carregando ? null : _enviar,
                  child: carregando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : Text(cadastrando ? 'CRIAR CONTA' : 'ENTRAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracao(String rotulo, IconData icone) {
    return InputDecoration(
      labelText: rotulo,
      prefixIcon: Icon(icone, color: Pallet.roxoLogo),
      filled: true,
      fillColor: Pallet.creme,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Pallet.rosaMagenta, width: 2),
      ),
    );
  }

  Widget _divisor() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Pallet.roxoLogo)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('ou', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Divider(color: Pallet.roxoLogo)),
      ],
    );
  }
}
