
import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';

class Progresso extends ChangeNotifier {
  Progresso._();

  static final Progresso instancia = Progresso._();

  final Map<int, int> _estrelas = {};

  final Set<String> _diasEstudados = {};

  // Gemas ganhas fazendo lições (as gastas na loja ficam em PerfilAluna).
  int _gemasGanhas = 0;

  int get gemasGanhas => _gemasGanhas;

  // Cada lição concluída vale 5 gemas por estrela,
  // e a primeira vez que a aluna conclui uma lição vale 10 gemas a mais.
  static int gemasPor(int estrelas, {required bool primeiraVez}) =>
      estrelas * 5 + (primeiraVez ? 10 : 0);

  bool _carregado = false;

  bool get carregado => _carregado;

  bool concluida(int numero) => _estrelas.containsKey(numero);

  int estrelasDa(int numero) => _estrelas[numero] ?? 0;

  int get totalEstrelas =>
      _estrelas.values.fold(0, (soma, e) => soma + e);

  int get totalConcluidas => _estrelas.length;

  bool liberada(int numero) =>
      numero == 1 || concluida(numero - 1);

  // Apaga o progresso da memória (quando a aluna sai da conta),
  // para a próxima aluna do mesmo aparelho não ver o progresso dela.
  void limpar() {
    _estrelas.clear();
    _diasEstudados.clear();
    _gemasGanhas = 0;
    _carregado = false;
    notifyListeners();
  }

  // Carrega o progresso da aluna logada, salvo no Firebase.
  // Se não der (ex.: sem internet), o app segue com o progresso zerado.
  Future<void> carregar() async {
    limpar();

    final List<Map<String, dynamic>> tentativas;
    try {
      tentativas = await DatabaseHelper.instancia
          .buscarTentativas()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Não foi possível carregar o progresso do Firebase: $e');
      return;
    }

    _estrelas.clear();
    _diasEstudados.clear();
    _gemasGanhas = 0;

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

      _gemasGanhas += gemasPor(estrelas, primeiraVez: !_estrelas.containsKey(numero));

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
  // Devolve quantas gemas a aluna ganhou nesta tentativa.
  int concluir(int numero, int estrelas) {
  final gemas = gemasPor(estrelas, primeiraVez: !concluida(numero));
  _gemasGanhas += gemas;

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
  return gemas;
}
}
