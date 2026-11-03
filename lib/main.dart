import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database/database_helper.dart';
import 'app/app.dart';
import 'app/progresso.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await Progresso.instancia.carregar();

  VideoPlayerMediaKit.ensureInitialized(
    android: true,
    linux: true,
  );

  runApp(const MyApp());
}