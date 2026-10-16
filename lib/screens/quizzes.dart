
import 'package:flutter/material.dart';

import '../data/quizzes.dart';
import '../widgets/video_player.dart';

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

    final titulo = quiz!['titulo'].toString();
    final video = quiz!['video'];
    final conteudo = quiz!['conteudo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 100,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 24),

                // Mostra o vídeo se houver um
                if (video != null) ...[
                  VideoWidget(
                    key: ValueKey(video),
                    nomeVideo: video as String,
                  ),
                  const SizedBox(height: 16),
                ],

                // Mostra o texto se houver conteúdo
                if (conteudo != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Sua missão',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            conteudo as String,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                ElevatedButton.icon(
                  onPressed: () {
                    // Depois vamos iniciar o quiz aqui.
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Começar missão'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
