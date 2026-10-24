
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../app/pallet.dart';

class VideoWidget extends StatefulWidget {
  final String nomeVideo;

  const VideoWidget({
    super.key,
    required this.nomeVideo,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late final VideoPlayerController controller;

  bool carregando = true;
  bool erro = false;

  @override
  void initState() {
    super.initState();
    iniciarVideo();
  }

  Future<void> iniciarVideo() async {
    controller = VideoPlayerController.asset(
      'assets/videos/${widget.nomeVideo}',
    );

    try {
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      await controller.play();
    } catch (e) {
      debugPrint('Erro ao carregar vídeo: $e');

      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = true;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Abre o mesmo vídeo numa tela preta ocupando tudo
  Future<void> abrirTelaCheia() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _TelaCheiaVideo(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (erro) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Pallet.lavanda,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.videocam_off_rounded, size: 48, color: Pallet.roxoLogo),
            SizedBox(height: 8),
            Text(
              'Não foi possível carregar o vídeo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Pallet.roxoAmeixa,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: _PlayerComControles(
          controller: controller,
          telaCheia: false,
          onTelaCheia: abrirTelaCheia,
        ),
      ),
    );
  }
}

// Tela cheia: usa o mesmo controller, então o vídeo continua de onde estava
class _TelaCheiaVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const _TelaCheiaVideo({required this.controller});

  @override
  State<_TelaCheiaVideo> createState() => _TelaCheiaVideoState();
}

class _TelaCheiaVideoState extends State<_TelaCheiaVideo> {
  @override
  void initState() {
    super.initState();
    // No celular: esconde as barras do sistema e deita a tela
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.preto,
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: _PlayerComControles(
            controller: widget.controller,
            telaCheia: true,
            onTelaCheia: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

// O vídeo com a barra de controles embaixo (play, volume, progresso e tela cheia)
class _PlayerComControles extends StatelessWidget {
  final VideoPlayerController controller;
  final bool telaCheia;
  final VoidCallback onTelaCheia;

  const _PlayerComControles({
    required this.controller,
    required this.telaCheia,
    required this.onTelaCheia,
  });

  void alternarPlay() {
    controller.value.isPlaying ? controller.pause() : controller.play();
  }

  @override
  Widget build(BuildContext context) {
    // Reconstrói sempre que o vídeo muda (tocando, pausado, volume...)
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, valor, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Toque no vídeo para pausar / continuar
            GestureDetector(
              onTap: alternarPlay,
              child: VideoPlayer(controller),
            ),
            if (!valor.isPlaying)
              IgnorePointer(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Pallet.rosaMagenta.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 48,
                    color: Pallet.branco,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _barraDeControles(valor),
            ),
          ],
        );
      },
    );
  }

  Widget _barraDeControles(VideoPlayerValue valor) {
    final mudo = valor.volume == 0;

    return Container(
      color: Pallet.roxoAmeixa.withValues(alpha: 0.75),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Pallet.rosaMagenta,
              bufferedColor: Pallet.lavanda,
              backgroundColor: Pallet.roxoLogo,
            ),
          ),
          Row(
            children: [
              IconButton(
                tooltip: valor.isPlaying ? 'Pausar' : 'Continuar',
                color: Pallet.branco,
                icon: Icon(
                  valor.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                onPressed: alternarPlay,
              ),

              // Toque no ícone para tirar / voltar o som
              IconButton(
                tooltip: mudo ? 'Ligar o som' : 'Tirar o som',
                color: Pallet.branco,
                icon: Icon(
                  mudo ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                ),
                onPressed: () => controller.setVolume(mudo ? 1 : 0),
              ),
              SizedBox(
                width: 110,
                child: SliderTheme(
                  data: const SliderThemeData(
                    activeTrackColor: Pallet.rosaMagenta,
                    inactiveTrackColor: Pallet.lavanda,
                    thumbColor: Pallet.branco,
                    trackHeight: 3,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                  ),
                  child: Slider(
                    value: valor.volume,
                    onChanged: controller.setVolume,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: telaCheia ? 'Sair da tela cheia' : 'Tela cheia',
                color: Pallet.branco,
                icon: Icon(
                  telaCheia ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                ),
                onPressed: onTelaCheia,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
