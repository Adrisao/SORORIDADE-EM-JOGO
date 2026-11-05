import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'app/app.dart';
import 'app/autenticacao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  VideoPlayerMediaKit.ensureInitialized(
    android: true,
    linux: true,
  );

  // Conecta ao Firebase. O progresso é carregado depois do login.
  await Autenticacao.instancia.iniciar();

  runApp(const MyApp());
}
