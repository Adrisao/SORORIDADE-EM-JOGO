import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'app/app.dart';
import 'app/progresso.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FFI somente para desktop.
  // Android e iOS usam o banco nativo do sqflite.
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  VideoPlayerMediaKit.ensureInitialized(
    android: true,
    linux: true,
  );

  await Progresso.instancia.carregar();

  runApp(const MyApp());
}
