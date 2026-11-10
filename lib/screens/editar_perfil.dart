import 'package:flutter/material.dart';

import '../app/autenticacao.dart';
import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../data/avatares.dart';
import '../widgets/avatar.dart';

// Tela para trocar o nome e escolher o avatar.
class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final perfil = PerfilAluna.instancia;
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nome = TextEditingController(
    text: Autenticacao.instancia.usuario?.displayName ?? '',
  );
  late String _avatar = perfil.avatar;
  bool _salvando = false;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _salvando = true);

    perfil.escolherAvatar(_avatar);

    final auth = Autenticacao.instancia;
    final nomeNovo = _nome.text.trim();
    String? erro;
    if (auth.disponivel && nomeNovo != (auth.usuario?.displayName ?? '')) {
      try {
        await auth.mudarNome(nomeNovo);
      } catch (e) {
        erro = Autenticacao.mensagemDeErro(e);
      }
    }

    if (!mounted) return;
    setState(() => _salvando = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: erro == null ? Pallet.verdeAgua : Pallet.rosaMagenta,
        content: Text(erro ?? 'Perfil atualizado!'),
      ));
    if (erro == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final escolhido = avatarPorId(_avatar);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: AvatarDesenho(
                base: escolhido,
                roupa: itemPorId(perfil.roupa),
                acessorio: itemPorId(perfil.acessorio),
                tamanho: 130,
                borda: Pallet.rosaMagenta,
              ),
            ),
            const SizedBox(height: 24),
            if (Autenticacao.instancia.disponivel) ...[
              const Text(
                'Seu nome',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Pallet.roxoAmeixa,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nome,
                maxLength: 30,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Pallet.branco,
                  prefixIcon: const Icon(Icons.person_rounded, color: Pallet.roxoLogo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (valor) => (valor == null || valor.trim().length < 2)
                    ? 'Escreva pelo menos 2 letras.'
                    : null,
              ),
              const SizedBox(height: 12),
            ],
            const Text(
              'Escolha seu avatar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Pallet.roxoAmeixa,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
              children: [
                for (final avatar in avatares) _opcaoDeAvatar(avatar),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvando ? null : _salvar,
              child: _salvando
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcaoDeAvatar(AvatarBase avatar) {
    final selecionado = avatar.id == _avatar;
    return GestureDetector(
      onTap: () => setState(() => _avatar = avatar.id),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, limites) => AvatarDesenho(
                base: avatar,
                roupa: itemPorId(perfil.roupa),
                tamanho: limites.biggest.shortestSide,
                fundo: selecionado ? Pallet.verdeAguaClaro : Pallet.lavanda,
                borda: selecionado ? Pallet.rosaMagenta : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            avatar.nome,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selecionado ? Pallet.rosaMagenta : Pallet.roxoAmeixa,
            ),
          ),
        ],
      ),
    );
  }
}
