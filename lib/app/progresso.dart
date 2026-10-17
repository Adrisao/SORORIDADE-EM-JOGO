
import 'package:flutter/foundation.dart';

// Guarda o progresso da aluna na trilha.
// Por enquanto fica só em memória: ao fechar o app o progresso é perdido.
class Progresso extends ChangeNotifier {
  Progresso._();

  static final Progresso instancia = Progresso._();

  // número da lição -> estrelas conquistadas (0 a 3)
  final Map<int, int> _estrelas = {};

  bool concluida(int numero) => _estrelas.containsKey(numero);

  int estrelasDa(int numero) => _estrelas[numero] ?? 0;

  int get totalEstrelas => _estrelas.values.fold(0, (soma, e) => soma + e);

  int get totalConcluidas => _estrelas.length;

  // A primeira lição está sempre liberada; as outras liberam
  // quando a anterior é concluída.
  bool liberada(int numero) => numero == 1 || concluida(numero - 1);

  void concluir(int numero, int estrelas) {
    // Mantém a melhor pontuação se a aluna refizer a lição
    if (estrelas >= estrelasDa(numero)) {
      _estrelas[numero] = estrelas;
    }
    notifyListeners();
  }
}
