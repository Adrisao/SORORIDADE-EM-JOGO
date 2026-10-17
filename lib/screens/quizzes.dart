
import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../data/quizzes.dart';
import '../widgets/comum.dart';
import '../widgets/video_player.dart';
import 'perguntas.dart';

// Tela do material da lição (texto, vídeo ou jogo).
// Depois do material a aluna segue para as perguntas.
class Quizzes extends StatefulWidget {
  // Qual quiz será carregado
  final int numeroQuiz;

  const Quizzes({
    super.key,
    required this.numeroQuiz,
  });

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  Map<String, dynamic>? quiz;

  @override
  void initState() {
    super.initState();

    // Tenta carregar o quiz
    try {
      quiz = quizzes.firstWhere(
        (q) => q['numero'] == widget.numeroQuiz,
      );
    } catch (e) {
      // O quiz não foi encontrado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // Volta para a página anterior
        Navigator.pop(context);

        // Mostra um aviso
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quiz não encontrado'),
            content: Text(
              'O quiz de número ${widget.numeroQuiz} não foi encontrado!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendi'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto não temos um quiz válido
    if (quiz == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final numero = quiz!['numero'] as int;
    final titulo = quiz!['titulo'].toString();
    final tipo = quiz!['tipoApresentacao'] as String?;
    final video = quiz!['video'];
    final conteudo = quiz!['conteudo'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lição $numero'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Pilula(
                            texto: nomeDoTipo(tipo),
                            icone: iconeDoTipo(tipo),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tituloCurto(titulo),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Pallet.roxoAmeixa,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Mostra o vídeo se houver um
                        if (video != null) ...[
                          VideoWidget(
                            key: ValueKey(video),
                            nomeVideo: video as String,
                          ),
                          const SizedBox(height: 20),
                        ] else if (tipo == 'video' || tipo == 'jogo') ...[
                          _emProducao(tipo!),
                          const SizedBox(height: 20),
                        ],

                        // Mostra o texto se houver conteúdo
                        if (conteudo != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tipo == 'texto' ? 'Leia com atenção' : 'Sobre esta lição',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Pallet.rosaMagenta,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    (conteudo as String).trim(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Botão fixo no rodapé
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Perguntas(quiz: quiz!),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Começar missão'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Espaço reservado para vídeos e minigames que ainda não foram produzidos
  Widget _emProducao(String tipo) {
    final ehJogo = tipo == 'jogo';

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Pallet.lavanda,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ehJogo ? Icons.sports_esports_rounded : Icons.videocam_rounded,
              size: 56,
              color: Pallet.roxoLogo,
            ),
            const SizedBox(height: 8),
            Text(
              ehJogo ? 'Minigame em construção' : 'Vídeo em produção',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Pallet.roxoAmeixa,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
