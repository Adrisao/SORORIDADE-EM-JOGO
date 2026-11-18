import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app/perfil_aluna.dart';
import 'package:flutter_application_1/app/progresso.dart';
import 'package:flutter_application_1/data/missoes.dart';
import 'package:flutter_application_1/screens/missoes.dart';
import 'package:flutter_application_1/screens/perfil.dart';

void main() {
  final progresso = Progresso.instancia;
  final perfil = PerfilAluna.instancia;

  Missao missao(String id) => missoes.firstWhere((m) => m.id == id);

  setUp(() {
    progresso.limpar();
    perfil.limpar();
  });

  test('missão só pode ser resgatada depois de cumprida, e uma vez só', () {
    final umaLicao = missao('diaria_uma_licao');
    expect(umaLicao.podeResgatar(progresso, perfil), isFalse);

    progresso.concluir(1, 2); // 20 gemas da lição
    expect(progresso.licoesHoje, 1);
    expect(progresso.licoesPerfeitasHoje, 0);
    expect(umaLicao.podeResgatar(progresso, perfil), isTrue);
    expect(missoesParaResgatar(progresso, perfil), 1);

    expect(
      perfil.resgatarMissao(umaLicao.id, diaria: true, gemas: umaLicao.gemas, xp: umaLicao.xp),
      isTrue,
    );
    expect(perfil.gemas, 20 + umaLicao.gemas);
    expect(perfil.xp, umaLicao.xp);
    expect(umaLicao.resgatada(perfil), isTrue);
    expect(missoesParaResgatar(progresso, perfil), 0);

    // Resgatar de novo não dá nada
    expect(
      perfil.resgatarMissao(umaLicao.id, diaria: true, gemas: umaLicao.gemas, xp: umaLicao.xp),
      isFalse,
    );
    expect(perfil.xp, umaLicao.xp);
  });

  test('nível sobe a cada 100 XP', () {
    progresso.concluir(1, 3);
    progresso.concluir(2, 3);
    progresso.concluir(3, 3);
    expect(perfil.nivel, 1);
    perfil.resgatarMissao('tres_licoes', diaria: false, gemas: 30, xp: 60);
    perfil.resgatarMissao('diaria_tres_licoes', diaria: true, gemas: 20, xp: 50);
    expect(perfil.xp, 110);
    expect(perfil.nivel, 2);
    expect(perfil.xpNoNivel, 10);
  });

  testWidgets('tela de missões abre e resgata', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3; // 360 de largura, como um celular
    addTearDown(tester.view.reset);

    progresso.concluir(1, 3);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Missoes())));
    expect(find.text('Missões de hoje'), findsOneWidget);
    expect(find.text('Nível 1'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Resgatar').first);
    await tester.pump();
    expect(find.text('Feito!'), findsOneWidget);
    expect(perfil.xp, greaterThan(0));
  });

  testWidgets('perfil mostra o nível e o XP', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    perfil.resgatarMissao('tres_licoes', diaria: false, gemas: 30, xp: 130);
    await tester.pumpWidget(const MaterialApp(home: Perfil()));
    expect(find.text('Nível 2  ·  130 XP'), findsOneWidget);
    expect(find.text('70 XP para o nível 3'), findsOneWidget);
  });
}
