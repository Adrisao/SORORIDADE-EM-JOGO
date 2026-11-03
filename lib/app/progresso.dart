
import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';

class Progresso extends ChangeNotifier {
  Progresso._();

  static final Progresso instancia = Progresso._();

  final Map<int, int> _estrelas = {};

  final Set<String> _diasEstudados = {};

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
    _diasEstudados.clear();

    for (final tentativa in tentativas) {
      final numero = tentativa['lesson_id'] as int;
      final erros = tentativa['erros'] as int;

      final data = DateTime.parse(tentativa['data'] as String);

      final dia = DateTime(data.year, data.month, data.day);

      _diasEstudados.add(
        '${dia.year.toString().padLeft(4, '0')}-'
        '${dia.month.toString().padLeft(2, '0')}-'
        '${dia.day.toString().padLeft(2, '0')}',
      );

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

int get diasSeguidos {
  if (_diasEstudados.isEmpty) return 0;

  final hoje = DateTime.now();
  final hojeData = DateTime(hoje.year, hoje.month, hoje.day);

  final dias = _diasEstudados
      .map((data) => DateTime.parse(data))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  final ultimoDia = dias.first;

  // Se estudou hoje ou ontem, a sequência ainda está ativa.
  final diferenca = hojeData.difference(ultimoDia).inDays;

  if (diferenca > 1) return 0;

  var sequencia = 1;
  var diaEsperado = ultimoDia.subtract(const Duration(days: 1));

  for (var i = 1; i < dias.length; i++) {
    if (dias[i] == diaEsperado) {
      sequencia++;
      diaEsperado = diaEsperado.subtract(const Duration(days: 1));
    } else if (dias[i].isBefore(diaEsperado)) {
      break;
    }
  }

  return sequencia;
}

  // Atualiza o progresso em memória após concluir uma lição.
  void concluir(int numero, int estrelas) {
  if (estrelas > estrelasDa(numero)) {
    _estrelas[numero] = estrelas;
  }

  final hoje = DateTime.now();

  final dia = DateTime(hoje.year, hoje.month, hoje.day);

  _diasEstudados.add(
    '${dia.year.toString().padLeft(4, '0')}-'
    '${dia.month.toString().padLeft(2, '0')}-'
    '${dia.day.toString().padLeft(2, '0')}',
  );

  notifyListeners();
}
}
