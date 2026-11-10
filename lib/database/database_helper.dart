import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Guarda as tentativas das lições no Firestore (Firebase).
//
// Estrutura no banco (cada aluna só acessa a própria pasta):
//   alunas/{uid}/tentativas/{id automático}
//     lesson_id: número da lição
//     erros:     quantos erros a aluna cometeu
//     data:      data/hora no aparelho da aluna (texto ISO 8601)
//     criadoEm:  data/hora do servidor do Firebase
//
//   alunas/{uid}  (documento do perfil)
//     avatar, roupa, acessorio: o que a aluna está usando
//     compradas:   lista das roupinhas compradas na loja
//     gemasGastas: total de gemas já gastas na loja
//     som:         efeitos sonoros ligados?
class DatabaseHelper {
  static final DatabaseHelper instancia = DatabaseHelper._();

  DatabaseHelper._();

  DocumentReference<Map<String, dynamic>> get _perfil {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Nenhuma aluna logada no Firebase.');
    }
    return FirebaseFirestore.instance.collection('alunas').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> get _tentativas =>
      _perfil.collection('tentativas');

  // Lê o perfil (avatar, roupinhas, gemas gastas). null se ainda não existe.
  Future<Map<String, dynamic>?> buscarPerfil() async {
    final doc = await _perfil.get();
    return doc.data();
  }

  // Grava o perfil inteiro de uma vez.
  Future<void> salvarPerfil(Map<String, dynamic> dados) async {
    await _perfil.set(dados);
  }

  // Salva uma tentativa assim que a lição é concluída.
  // Sem internet, o Firestore guarda no aparelho e envia quando voltar.
  Future<void> salvarTentativa({
    required int lessonId,
    required int erros,
  }) async {
    await _tentativas.add({
      'lesson_id': lessonId,
      'erros': erros,
      'data': DateTime.now().toIso8601String(),
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  // Recupera todas as tentativas da aluna, da mais antiga para a mais nova.
  Future<List<Map<String, dynamic>>> buscarTentativas() async {
    final resultado = await _tentativas.orderBy('data').get();

    return [for (final doc in resultado.docs) doc.data()];
  }
}
