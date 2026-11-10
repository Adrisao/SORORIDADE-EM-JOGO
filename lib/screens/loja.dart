import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../app/progresso.dart';
import '../data/avatares.dart';
import '../widgets/avatar.dart';

// Loja de roupinhas: a aluna gasta as gemas que ganhou nas lições.
class Loja extends StatelessWidget {
  const Loja({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = PerfilAluna.instancia;

    return DefaultTabController(
      length: 2,
      child: ListenableBuilder(
        listenable: Listenable.merge([perfil, Progresso.instancia]),
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Loja de roupinhas'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SaldoDeGemas(gemas: perfil.gemas),
              ),
            ],
            bottom: const TabBar(
              labelColor: Pallet.branco,
              unselectedLabelColor: Pallet.lavanda,
              indicatorColor: Pallet.branco,
              indicatorWeight: 4,
              labelStyle: TextStyle(
                fontFamily: Pallet.fonte,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              tabs: [
                Tab(icon: Icon(Icons.checkroom_rounded), text: 'Roupas'),
                Tab(icon: Icon(Icons.auto_awesome_rounded), text: 'Acessórios'),
              ],
            ),
          ),
          body: Column(
            children: [
              _vitrine(perfil),
              Expanded(
                child: TabBarView(
                  children: [
                    _grade(context, TipoItem.roupa),
                    _grade(context, TipoItem.acessorio),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Avatar grande com o que está sendo usado agora
  Widget _vitrine(PerfilAluna perfil) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Pallet.roxoAmeixa,
      child: Row(
        children: [
          const AvatarDaAluna(tamanho: 90, borda: Pallet.rosaMagenta),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Faça lições para ganhar gemas e deixe seu avatar do seu jeito!',
              style: TextStyle(
                color: Pallet.branco,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grade(BuildContext context, TipoItem tipo) {
    final itens = itensDaLoja.where((i) => i.tipo == tipo).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: itens.length,
      itemBuilder: (context, i) => _cartao(context, itens[i]),
    );
  }

  Widget _cartao(BuildContext context, ItemLoja item) {
    final perfil = PerfilAluna.instancia;
    final comprado = perfil.comprou(item.id);
    final vestindo = perfil.vestindo(item);

    // Mostra o avatar da aluna já usando a peça
    final roupa = item.tipo == TipoItem.roupa ? item : itemPorId(perfil.roupa);
    final acessorio = item.tipo == TipoItem.acessorio ? item : null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: vestindo ? Pallet.rosaMagenta : Pallet.lavanda,
          width: vestindo ? 3 : 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _tocar(context, item),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, limites) => AvatarDesenho(
                    base: avatarPorId(perfil.avatar),
                    roupa: roupa,
                    acessorio: acessorio,
                    tamanho: limites.biggest.shortestSide,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.nome,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Pallet.roxoAmeixa,
                ),
              ),
              const SizedBox(height: 6),
              _etiqueta(item, comprado, vestindo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _etiqueta(ItemLoja item, bool comprado, bool vestindo) {
    final String texto;
    final Color fundo;
    final Color cor;
    IconData? icone;

    if (vestindo) {
      texto = 'USANDO';
      fundo = Pallet.rosaMagenta;
      cor = Pallet.branco;
      icone = Icons.check_rounded;
    } else if (comprado) {
      texto = 'VESTIR';
      fundo = Pallet.verdeAguaClaro;
      cor = Pallet.roxoAmeixa;
    } else {
      texto = '${item.preco}';
      fundo = Pallet.lavanda;
      cor = Pallet.roxoAmeixa;
      icone = Icons.diamond_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: fundo, borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 16, color: comprado ? cor : Pallet.gema),
            const SizedBox(width: 4),
          ],
          Text(
            texto,
            style: TextStyle(color: cor, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Future<void> _tocar(BuildContext context, ItemLoja item) async {
    final perfil = PerfilAluna.instancia;

    if (perfil.comprou(item.id)) {
      perfil.vestir(item);
      return;
    }

    if (perfil.gemas < item.preco) {
      final faltam = item.preco - perfil.gemas;
      _avisar(
        context,
        'Faltam $faltam gemas. Faça lições para ganhar mais!',
        Pallet.roxoAmeixa,
      );
      return;
    }

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comprar ${item.nome}?'),
        content: Row(
          children: [
            const Text('Custa ', style: TextStyle(fontSize: 16)),
            const Icon(Icons.diamond_rounded, color: Pallet.gema, size: 20),
            Text(
              ' ${item.preco} gemas.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Agora não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );
    if (confirmou != true || !context.mounted) return;

    if (perfil.comprar(item)) {
      _avisar(context, '${item.nome} é sua! Já está vestindo.', Pallet.verdeAgua);
    }
  }

  void _avisar(BuildContext context, String texto, Color cor) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(backgroundColor: cor, content: Text(texto)));
  }
}
