import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/avatares.dart';
import '../database/database_helper.dart';
import 'autenticacao.dart';
import 'progresso.dart';

// Escolhas da aluna que ficam salvas no Firebase:
// avatar, roupinhas compradas e vestidas, gemas gastas e configurações.
class PerfilAluna extends ChangeNotifier {
  PerfilAluna._();

  static final PerfilAluna instancia = PerfilAluna._();

  String _avatar = avatares.first.id;
  String _roupa = roupaInicial;
  String? _acessorio;
  final Set<String> _compradas = {roupaInicial};
  int _gemasGastas = 0;
  bool _som = true;

  String get avatar => _avatar;
  String get roupa => _roupa;
  String? get acessorio => _acessorio;
  bool get som => _som;
  int get gemasGastas => _gemasGastas;

  // Saldo = gemas ganhas nas lições - gemas gastas na loja.
  int get gemas => max(0, Progresso.instancia.gemasGanhas - _gemasGastas);

  bool comprou(String id) => _compradas.contains(id);

  int get totalCompradas => _compradas.length - 1; // sem contar a roupa inicial

  bool vestindo(ItemLoja item) =>
      item.tipo == TipoItem.roupa ? _roupa == item.id : _acessorio == item.id;

  void limpar() {
    _avatar = avatares.first.id;
    _roupa = roupaInicial;
    _acessorio = null;
    _compradas
      ..clear()
      ..add(roupaInicial);
    _gemasGastas = 0;
    _som = true;
    notifyListeners();
  }

  Future<void> carregar() async {
    limpar();
    if (!Autenticacao.instancia.disponivel) return;

    final Map<String, dynamic>? dados;
    try {
      dados = await DatabaseHelper.instancia
          .buscarPerfil()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Não foi possível carregar o perfil do Firebase: $e');
      return;
    }
    if (dados == null) return;

    // Ignora peças que não existem mais no catálogo.
    final compradas = (dados['compradas'] as List?)?.whereType<String>() ?? [];
    _compradas.addAll(compradas.where((id) => itemPorId(id) != null));

    _avatar = avatarPorId(dados['avatar'] as String?).id;

    final roupa = dados['roupa'] as String?;
    if (roupa != null && _compradas.contains(roupa)) _roupa = roupa;

    final acessorio = dados['acessorio'] as String?;
    _acessorio = (acessorio != null && _compradas.contains(acessorio)) ? acessorio : null;

    _gemasGastas = (dados['gemasGastas'] as num?)?.toInt() ?? 0;
    _som = dados['som'] as bool? ?? true;
    notifyListeners();
  }

  void escolherAvatar(String id) {
    _avatar = avatarPorId(id).id;
    _alterou();
  }

  // Veste a peça (ou tira, se for um acessório que já está sendo usado).
  void vestir(ItemLoja item) {
    if (!comprou(item.id)) return;
    if (item.tipo == TipoItem.roupa) {
      _roupa = item.id;
    } else {
      _acessorio = _acessorio == item.id ? null : item.id;
    }
    _alterou();
  }

  // Compra e já veste a peça. Devolve false se faltarem gemas.
  bool comprar(ItemLoja item) {
    if (comprou(item.id)) return true;
    if (gemas < item.preco) return false;
    _gemasGastas += item.preco;
    _compradas.add(item.id);
    vestir(item); // já salva e avisa as telas
    return true;
  }

  void mudarSom(bool ligado) {
    _som = ligado;
    _alterou();
  }

  void _alterou() {
    notifyListeners();
    if (!Autenticacao.instancia.disponivel) return;

    // Salva em segundo plano; sem internet o Firestore envia depois.
    DatabaseHelper.instancia.salvarPerfil({
      'avatar': _avatar,
      'roupa': _roupa,
      'acessorio': _acessorio,
      'compradas': _compradas.toList(),
      'gemasGastas': _gemasGastas,
      'som': _som,
    }).catchError((Object e) {
      debugPrint('Não foi possível salvar o perfil no Firebase: $e');
    });
  }
}
