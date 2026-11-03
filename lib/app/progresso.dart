
import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';

class Progresso extends ChangeNotifier {
  Progresso._();

  static final Progresso instancia = Progresso._();

  final Map<int, int> _estrelas = {};

  bool _carregado = false;

  bool get carregado => _carregado;

  bool concluida(int numero) => _estrelas.containsKey(numero);

  int estrelasDa(int numero) => _estrelas[numero] ?? 0;

  int get totalEstrelas =>
      _estrelas.values.fold(0, (soma, e) => soma + e);

  int get totalConcluidas => _estrelas.length;

  bool liberada(int numero) =>
      numero == 1 || concluida(numero - 1);

  // Carrega o progresso salvo no SQLite.
  Future<void> carregar() async {
    if (_carregado) return;

    final tentativas =
        await DatabaseHelper.instancia.buscarTentativas();

    _estrelas.clear();

    for (final tentativa in tentativas) {
      final numero = tentativa['lesson_id'] as int;
      final erros = tentativa['erros'] as int;

      final estrelas = erros == 0
          ? 3
          : (erros <= 2 ? 2 : 1);

      // Guarda somente a melhor pontuação da lição.
      if (estrelas > (_estrelas[numero] ?? 0)) {
        _estrelas[numero] = estrelas;
      }
    }

    _carregado = true;
    notifyListeners();
  }

  // Atualiza o progresso em memória após concluir uma lição.
  void concluir(int numero, int estrelas) {
    if (estrelas > estrelasDa(numero)) {
      _estrelas[numero] = estrelas;
    }

    notifyListeners();
  }
}
