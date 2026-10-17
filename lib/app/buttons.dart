import 'package:flutter/material.dart';
import '../screens/quizzes.dart';
import '../widgets/comum.dart';
import 'pallet.dart';
import 'progresso.dart';

// Botão redondo de uma lição na trilha (estilo Duolingo).
class Buttons extends StatelessWidget {
  final Map<String, dynamic> licao;

  const Buttons({super.key, required this.licao});

  @override
  Widget build(BuildContext context) {
    final progresso = Progresso.instancia;
    final numero = licao['numero'] as int;
    final tipo = licao['tipoApresentacao'] as String?;

    final concluida = progresso.concluida(numero);
    final liberada = progresso.liberada(numero);
    final atual = liberada && !concluida;

    // Cor do botão conforme o estado da lição
    final Color cor;
    final Color sombra;
    final IconData icone;
    if (concluida) {
      cor = Pallet.verdeAgua;
      sombra = Color.lerp(Pallet.verdeAgua, Pallet.textoEscuro, 0.3)!;
      icone = Icons.check_rounded;
    } else if (atual) {
      cor = Pallet.rosaMagenta;
      sombra = Pallet.roxoAmeixa;
      icone = iconeDoTipo(tipo);
    } else {
      cor = Pallet.lavanda;
      sombra = Pallet.roxoLogo.withValues(alpha: 0.35);
      icone = Icons.lock_rounded;
    }

    // O círculo e o nome da lição respondem ao toque
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!liberada) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Pallet.roxoAmeixa,
                content: Text('Conclua a lição anterior para liberar esta!'),
              ),
            );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Quizzes(numeroQuiz: numero)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Balãozinho "Começar" em cima da lição atual
          if (atual)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Pallet.branco,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Pallet.lavanda, width: 2),
              ),
              child: const Text(
                'COMEÇAR',
                style: TextStyle(
                  color: Pallet.rosaMagenta,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),

          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              // "Degrau" embaixo do botão, como no Duolingo
              boxShadow: [BoxShadow(color: sombra, offset: const Offset(0, 6))],
            ),
            child: Icon(
              icone,
              size: 38,
              color: liberada ? Pallet.branco : Pallet.roxoLogo,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: 150,
            child: Text(
              tituloCurto(licao['titulo'].toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: liberada ? Pallet.roxoAmeixa : Pallet.roxoLogo,
              ),
            ),
          ),

          if (concluida) ...[
            const SizedBox(height: 4),
            Estrelas(quantidade: progresso.estrelasDa(numero), tamanho: 16),
          ],
        ],
      ),
    );
  }
}
