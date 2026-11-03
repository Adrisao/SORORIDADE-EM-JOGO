
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instancia = DatabaseHelper._();

  DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _inicializarBanco();
    return _database!;
  }

  Future<Database> _inicializarBanco() async {
    final diretorio = await getDatabasesPath();
    final caminho = join(diretorio, 'aprendizado.db');

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE attempts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lesson_id INTEGER NOT NULL,
            erros INTEGER NOT NULL,
            data TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Salva uma tentativa assim que a lição é concluída.
  Future<void> salvarTentativa({
    required int lessonId,
    required int erros,
  }) async {
    final db = await database;

    await db.insert(
      'attempts',
      {
        'lesson_id': lessonId,
        'erros': erros,
        'data': DateTime.now().toIso8601String(),
      },
    );
  }

  // Recupera todas as tentativas salvas.
  Future<List<Map<String, dynamic>>> buscarTentativas() async {
    final db = await database;

    return await db.query(
      'attempts',
      orderBy: 'data ASC',
    );
  }
}
