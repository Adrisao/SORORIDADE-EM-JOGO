import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/avatares.dart';
import '../database/database_helper.dart';
import 'autenticacao.dart';
import 'progresso.dart';

// Escolhas da aluna que ficam salvas no Firebase:
// avatar, roupinhas compradas e vestidas, gemas gastas, configurações,
// XP e missões resgatadas.
class PerfilAluna extends ChangeNotifier {
  PerfilAluna._();

  static final PerfilAluna instancia = PerfilAluna._();

  String _avatar = avatares.first.id;
  String _roupa = roupaInicial;
  String? _acessorio;
  final Set<String> _compradas = {roupaInicial};
  int _gemasGastas = 0;
  bool _som = true;

  // Missões: XP e gemas ganhos resgatando missões.
  int _xp = 0;
  int _gemasMissoes = 0;
  // Missões especiais (só podem ser resgatadas uma vez).
  final Set<String> _missoesResgatadas = {};
  // Missões diárias resgatadas no dia _diaDasDiarias ('2026-11-18').
  final Set<String> _diariasResgatadas = {};
  String _diaDasDiarias = '';

  static const int xpPorNivel = 100;

  String get avatar => _avatar;
  String get roupa => _roupa;
  String? get acessorio => _acessorio;
  bool get som => _som;
  int get gemasGastas => _gemasGastas;

  int get xp => _xp;
  int get nivel => 1 + _xp ~/ xpPorNivel;
  int get xpNoNivel => _xp % xpPorNivel;

  // Saldo = gemas ganhas nas lições e missões - gemas gastas na loja.
  int get gemas =>
      max(0, Progresso.instancia.gemasGanhas + _gemasMissoes - _gemasGastas);

  bool resgatou(String missao, {required bool diaria}) => diaria
      ? _diaDasDiarias == Progresso.chaveDoDia(DateTime.now()) &&
          _diariasResgatadas.contains(missao)
      : _missoesResgatadas.contains(missao);

  // Entrega as gemas e o XP de uma missão concluída.
  // Devolve false se ela já tinha sido resgatada.
  bool resgatarMissao(
    String missao, {
    required bool diaria,
    required int gemas,
    required int xp,
  }) {
    if (resgatou(missao, diaria: diaria)) return false;
    if (diaria) {
      final hoje = Progresso.chaveDoDia(DateTime.now());
      if (_diaDasDiarias != hoje) {
        _diaDasDiarias = hoje;
        _diariasResgatadas.clear();
      }
      _diariasResgatadas.add(missao);
    } else {
      _missoesResgatadas.add(missao);
    }
    _gemasMissoes += gemas;
    _xp += xp;
    _alterou();
    return true;
  }

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
    _xp = 0;
    _gemasMissoes = 0;
    _missoesResgatadas.clear();
    _diariasResgatadas.clear();
    _diaDasDiarias = '';
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

    _xp = (dados['xp'] as num?)?.toInt() ?? 0;
    _gemasMissoes = (dados['gemasMissoes'] as num?)?.toInt() ?? 0;
    _missoesResgatadas.addAll(
        (dados['missoesResgatadas'] as List?)?.whereType<String>() ?? []);
    _diaDasDiarias = dados['diaDasDiarias'] as String? ?? '';
    _diariasResgatadas.addAll(
        (dados['diariasResgatadas'] as List?)?.whereType<String>() ?? []);
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
      'xp': _xp,
      'gemasMissoes': _gemasMissoes,
      'missoesResgatadas': _missoesResgatadas.toList(),
      'diaDasDiarias': _diaDasDiarias,
      'diariasResgatadas': _diariasResgatadas.toList(),
    }).catchError((Object e) {
      debugPrint('Não foi possível salvar o perfil no Firebase: $e');
    });
  }
}
