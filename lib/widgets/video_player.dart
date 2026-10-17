
import 'package:flutter/material.dart';
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

    // Toque no vídeo para pausar / continuar
    return GestureDetector(
      onTap: () {
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(controller),
              if (!controller.value.isPlaying)
                Container(
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
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Pallet.rosaMagenta,
                    bufferedColor: Pallet.lavanda,
                    backgroundColor: Pallet.roxoLogo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
