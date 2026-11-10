import 'package:flutter/material.dart';

import '../app/pallet.dart';

// Catálogo dos avatares e das roupinhas da loja.
// Os desenhos são feitos em código (widgets/avatar.dart), sem imagens.

enum Penteado { longo, ondulado, cacheado, puff, trancas, coques, curto, rabo }

// Avatar base: tom de pele + cabelo. A aluna escolhe um no "Editar perfil".
class AvatarBase {
  final String id;
  final String nome;
  final Color pele;
  final Color cabelo;
  final Penteado penteado;

  const AvatarBase({
    required this.id,
    required this.nome,
    required this.pele,
    required this.cabelo,
    required this.penteado,
  });
}

const List<AvatarBase> avatares = [
  AvatarBase(id: 'luna', nome: 'Luna', pele: Pallet.peleClara, cabelo: Pallet.cabeloCastanho, penteado: Penteado.longo),
  AvatarBase(id: 'maya', nome: 'Maya', pele: Pallet.peleMarrom, cabelo: Pallet.cabeloPreto, penteado: Penteado.cacheado),
  AvatarBase(id: 'bia', nome: 'Bia', pele: Pallet.pelePessego, cabelo: Pallet.cabeloRuivo, penteado: Penteado.trancas),
  AvatarBase(id: 'jade', nome: 'Jade', pele: Pallet.peleMorena, cabelo: Pallet.cabeloPreto, penteado: Penteado.coques),
  AvatarBase(id: 'sol', nome: 'Sol', pele: Pallet.peleClara, cabelo: Pallet.cabeloLoiro, penteado: Penteado.curto),
  AvatarBase(id: 'iara', nome: 'Iara', pele: Pallet.peleParda, cabelo: Pallet.cabeloPreto, penteado: Penteado.rabo),
  AvatarBase(id: 'nina', nome: 'Nina', pele: Pallet.peleEscura, cabelo: Pallet.cabeloRoxo, penteado: Penteado.puff),
  AvatarBase(id: 'clara', nome: 'Clara', pele: Pallet.pelePessego, cabelo: Pallet.cabeloRosa, penteado: Penteado.ondulado),
  AvatarBase(id: 'kaya', nome: 'Kaya', pele: Pallet.peleParda, cabelo: Pallet.cabeloCastanho, penteado: Penteado.ondulado),
  AvatarBase(id: 'zara', nome: 'Zara', pele: Pallet.peleEscura, cabelo: Pallet.cabeloPreto, penteado: Penteado.trancas),
  AvatarBase(id: 'ana', nome: 'Ana', pele: Pallet.peleMarrom, cabelo: Pallet.cabeloCastanho, penteado: Penteado.curto),
  AvatarBase(id: 'lia', nome: 'Lia', pele: Pallet.peleMorena, cabelo: Pallet.cabeloLoiro, penteado: Penteado.longo),
];

// Desenho de cada peça da loja.
enum Estilo {
  // roupas
  camiseta,
  listrada,
  coracao,
  estrela,
  arcoIris,
  time,
  vestido,
  moletom,
  jaqueta,
  macacao,
  princesa,
  heroina,
  // acessórios
  laco,
  flor,
  oculos,
  oculosCoracao,
  bone,
  orelhasGato,
  coroaFlores,
  fone,
  tiara,
  unicornio,
  coroa,
}

enum TipoItem { roupa, acessorio }

class ItemLoja {
  final String id;
  final String nome;
  final TipoItem tipo;
  final int preco; // em gemas (0 = grátis)
  final Estilo estilo;
  final Color cor;
  final Color detalhe;

  const ItemLoja({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.preco,
    required this.estilo,
    required this.cor,
    this.detalhe = Pallet.branco,
  });
}

// Roupa que toda aluna já começa usando.
const String roupaInicial = 'camiseta_rosa';

// Atenção: não mude o id de uma peça que já existe,
// senão quem comprou perde a peça.
const List<ItemLoja> itensDaLoja = [
  // Roupas
  ItemLoja(id: roupaInicial, nome: 'Camiseta rosa', tipo: TipoItem.roupa, preco: 0,
      estilo: Estilo.camiseta, cor: Pallet.rosaMagenta),
  ItemLoja(id: 'camiseta_verde', nome: 'Camiseta verde-água', tipo: TipoItem.roupa, preco: 20,
      estilo: Estilo.camiseta, cor: Pallet.verdeAgua),
  ItemLoja(id: 'listrada', nome: 'Blusa listrada', tipo: TipoItem.roupa, preco: 30,
      estilo: Estilo.listrada, cor: Pallet.azulCeu, detalhe: Pallet.branco),
  ItemLoja(id: 'coracao', nome: 'Blusa de coração', tipo: TipoItem.roupa, preco: 40,
      estilo: Estilo.coracao, cor: Pallet.lavanda, detalhe: Pallet.rosaMagenta),
  ItemLoja(id: 'estrela', nome: 'Blusa de estrela', tipo: TipoItem.roupa, preco: 40,
      estilo: Estilo.estrela, cor: Pallet.roxoAmeixa, detalhe: Pallet.amareloSol),
  ItemLoja(id: 'time', nome: 'Camisa do time', tipo: TipoItem.roupa, preco: 45,
      estilo: Estilo.time, cor: Pallet.amareloSol, detalhe: Pallet.verdeFolha),
  ItemLoja(id: 'arco_iris', nome: 'Blusa arco-íris', tipo: TipoItem.roupa, preco: 50,
      estilo: Estilo.arcoIris, cor: Pallet.branco),
  ItemLoja(id: 'vestido', nome: 'Vestido de festa', tipo: TipoItem.roupa, preco: 60,
      estilo: Estilo.vestido, cor: Pallet.vermelhoCoral, detalhe: Pallet.branco),
  ItemLoja(id: 'moletom', nome: 'Moletom aconchegante', tipo: TipoItem.roupa, preco: 70,
      estilo: Estilo.moletom, cor: Pallet.roxoLogo, detalhe: Pallet.lavanda),
  ItemLoja(id: 'jaqueta', nome: 'Jaqueta jeans', tipo: TipoItem.roupa, preco: 90,
      estilo: Estilo.jaqueta, cor: Pallet.azulJeans, detalhe: Pallet.rosaClaro),
  ItemLoja(id: 'macacao', nome: 'Jardineira', tipo: TipoItem.roupa, preco: 100,
      estilo: Estilo.macacao, cor: Pallet.azulCeu, detalhe: Pallet.rosaMagenta),
  ItemLoja(id: 'princesa', nome: 'Vestido de princesa', tipo: TipoItem.roupa, preco: 110,
      estilo: Estilo.princesa, cor: Pallet.lilasBrilho, detalhe: Pallet.rosaMagenta),
  ItemLoja(id: 'heroina', nome: 'Roupa de super-heroína', tipo: TipoItem.roupa, preco: 130,
      estilo: Estilo.heroina, cor: Pallet.rosaMagenta, detalhe: Pallet.roxoAmeixa),

  // Acessórios
  ItemLoja(id: 'laco', nome: 'Laço', tipo: TipoItem.acessorio, preco: 15,
      estilo: Estilo.laco, cor: Pallet.rosaMagenta),
  ItemLoja(id: 'flor', nome: 'Flor no cabelo', tipo: TipoItem.acessorio, preco: 20,
      estilo: Estilo.flor, cor: Pallet.amareloSol, detalhe: Pallet.vermelhoCoral),
  ItemLoja(id: 'oculos', nome: 'Óculos redondos', tipo: TipoItem.acessorio, preco: 30,
      estilo: Estilo.oculos, cor: Pallet.roxoAmeixa),
  ItemLoja(id: 'bone', nome: 'Boné', tipo: TipoItem.acessorio, preco: 35,
      estilo: Estilo.bone, cor: Pallet.verdeAgua, detalhe: Pallet.branco),
  ItemLoja(id: 'orelhas_gato', nome: 'Orelhas de gatinha', tipo: TipoItem.acessorio, preco: 40,
      estilo: Estilo.orelhasGato, cor: Pallet.cinzaGrafite, detalhe: Pallet.rosaClaro),
  ItemLoja(id: 'oculos_sol', nome: 'Óculos de coração', tipo: TipoItem.acessorio, preco: 45,
      estilo: Estilo.oculosCoracao, cor: Pallet.rosaMagenta),
  ItemLoja(id: 'coroa_flores', nome: 'Coroa de flores', tipo: TipoItem.acessorio, preco: 55,
      estilo: Estilo.coroaFlores, cor: Pallet.rosaClaro, detalhe: Pallet.amareloSol),
  ItemLoja(id: 'fone', nome: 'Fone de ouvido', tipo: TipoItem.acessorio, preco: 60,
      estilo: Estilo.fone, cor: Pallet.verdeAgua, detalhe: Pallet.cinzaGrafite),
  ItemLoja(id: 'tiara', nome: 'Tiara de estrelas', tipo: TipoItem.acessorio, preco: 80,
      estilo: Estilo.tiara, cor: Pallet.amareloSol, detalhe: Pallet.roxoLogo),
  ItemLoja(id: 'unicornio', nome: 'Tiara de unicórnio', tipo: TipoItem.acessorio, preco: 100,
      estilo: Estilo.unicornio, cor: Pallet.dourado, detalhe: Pallet.rosaClaro),
  ItemLoja(id: 'coroa', nome: 'Coroa de rainha', tipo: TipoItem.acessorio, preco: 120,
      estilo: Estilo.coroa, cor: Pallet.dourado, detalhe: Pallet.rosaMagenta),
];

AvatarBase avatarPorId(String? id) =>
    avatares.firstWhere((a) => a.id == id, orElse: () => avatares.first);

ItemLoja? itemPorId(String? id) {
  for (final item in itensDaLoja) {
    if (item.id == id) return item;
  }
  return null;
}
