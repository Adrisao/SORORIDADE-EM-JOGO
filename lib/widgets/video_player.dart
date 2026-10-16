
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      return const Center(
        child: Text('Não foi possível carregar o vídeo.'),
      );
    }

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
