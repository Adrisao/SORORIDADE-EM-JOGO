
import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/progresso.dart';
import '../widgets/comum.dart';

// Tela das 3 perguntas de múltipla escolha de uma lição.
class Perguntas extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const Perguntas({
    super.key,
    required this.quiz,
  });

  @override
  State<Perguntas> createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {
  int atual = 0; // índice da pergunta atual
  int? escolhida; // alternativa que a aluna tocou
  bool verificada = false; // já apertou "Verificar"?
  int acertos = 0;
  bool terminou = false;

  List<Map<String, dynamic>> get perguntas =>
      (widget.quiz['perguntas'] as List).cast<Map<String, dynamic>>();

  Map<String, dynamic> get pergunta => perguntas[atual];

  bool get acertou => escolhida == pergunta['respostaCorreta'];

  void verificar() {
    setState(() {
      verificada = true;
      if (acertou) acertos++;
    });
  }

  void continuar() {
    setState(() {
      if (atual + 1 < perguntas.length) {
        atual++;
        escolhida = null;
        verificada = false;
      } else {
        terminou = true;
        Progresso.instancia.concluir(widget.quiz['numero'] as int, acertos);
      }
    });
  }

  void recomecar() {
    setState(() {
      atual = 0;
      escolhida = null;
      verificada = false;
      acertos = 0;
      terminou = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (terminou) return _resultado();

    // Barra avança conforme a aluna responde
    final avanco = (atual + (verificada ? 1 : 0)) / perguntas.length;
    final alternativas = (pergunta['alternativas'] as List).cast<String>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Topo: fechar + barra de progresso
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 30),
                    color: Pallet.roxoLogo,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: avanco),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, valor, _) => LinearProgressIndicator(
                          value: valor,
                          minHeight: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Pilula(
                      texto: 'PERGUNTA ${atual + 1} DE ${perguntas.length}',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pergunta['enunciado'].toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Pallet.roxoAmeixa,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < alternativas.length; i++) ...[
                      _alternativa(i, alternativas[i]),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),

            _rodape(alternativas),
          ],
        ),
      ),
    );
  }

  Widget _alternativa(int indice, String texto) {
    final correta = pergunta['respostaCorreta'] as int;
    final selecionada = escolhida == indice;

    // Cores padrão
    Color fundo = Pallet.branco;
    Color borda = Pallet.lavanda;
    Color letraFundo = Pallet.lavanda;
    Color letraCor = Pallet.roxoAmeixa;

    if (verificada && indice == correta) {
      fundo = Pallet.verdeAguaClaro;
      borda = Pallet.verdeAgua;
      letraFundo = Pallet.verdeAgua;
      letraCor = Pallet.branco;
    } else if (verificada && selecionada) {
      fundo = Pallet.lavanda;
      borda = Pallet.rosaMagenta;
      letraFundo = Pallet.rosaMagenta;
      letraCor = Pallet.branco;
    } else if (selecionada) {
      borda = Pallet.rosaMagenta;
      letraFundo = Pallet.rosaMagenta;
      letraCor = Pallet.branco;
    }

    return GestureDetector(
      onTap: verificada ? null : () => setState(() => escolhida = indice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borda, width: 2.5),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: letraFundo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                String.fromCharCode(65 + indice), // A, B, C, D
                style: TextStyle(
                  color: letraCor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rodapé com o botão Verificar / Continuar e o feedback da resposta
  Widget _rodape(List<String> alternativas) {
    if (!verificada) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: escolhida == null ? null : verificar,
            child: const Text('Verificar'),
          ),
        ),
      );
    }

    final correta = alternativas[pergunta['respostaCorreta'] as int];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: acertou ? Pallet.verdeAguaClaro : Pallet.lavanda,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                acertou ? Icons.check_circle_rounded : Icons.favorite_rounded,
                color: acertou ? Pallet.verdeAgua : Pallet.rosaMagenta,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                acertou ? 'Muito bem!' : 'Quase lá!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: acertou ? Pallet.roxoAmeixa : Pallet.rosaMagenta,
                ),
              ),
            ],
          ),
          if (!acertou) ...[
            const SizedBox(height: 6),
            Text(
              'Resposta certa: $correta',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: acertou ? Pallet.verdeAgua : Pallet.rosaMagenta,
              ),
              onPressed: continuar,
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultado() {
    final total = perguntas.length;
    final String mensagem;
    if (acertos == total) {
      mensagem = 'Incrível! Você acertou tudo!';
    } else if (acertos > 0) {
      mensagem = 'Bom trabalho! Continue praticando.';
    } else {
      mensagem = 'Não desanime! Que tal tentar de novo?';
    }

    return Scaffold(
      backgroundColor: Pallet.roxoAmeixa,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: Pallet.roxoLogo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 72,
                  color: Pallet.branco,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Lição concluída!',
                style: TextStyle(
                  color: Pallet.branco,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tituloCurto(widget.quiz['titulo'].toString()),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Pallet.lavanda, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Pallet.branco,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Estrelas(quantidade: acertos, tamanho: 44),
              ),
              const SizedBox(height: 16),
              Pilula(texto: '$acertos DE $total ACERTOS'),
              const SizedBox(height: 16),
              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Pallet.branco,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar para a trilha'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Pallet.branco,
                    side: const BorderSide(color: Pallet.branco, width: 2),
                  ),
                  onPressed: recomecar,
                  child: const Text('Tentar de novo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
