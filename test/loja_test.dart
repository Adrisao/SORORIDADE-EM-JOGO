import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app/perfil_aluna.dart';
import 'package:flutter_application_1/app/progresso.dart';
import 'package:flutter_application_1/data/avatares.dart';
import 'package:flutter_application_1/screens/loja.dart';
import 'package:flutter_application_1/screens/perfil.dart';
import 'package:flutter_application_1/widgets/avatar.dart';

void main() {
  final progresso = Progresso.instancia;
  final perfil = PerfilAluna.instancia;

  setUp(() {
    progresso.limpar();
    perfil.limpar();
  });

  test('gemas: 5 por estrela + 10 na primeira vez', () {
    expect(progresso.concluir(1, 3), 25);
    expect(progresso.concluir(1, 2), 10); // repetindo, sem bônus
    expect(progresso.gemasGanhas, 35);
    expect(perfil.gemas, 35);
  });

  test('comprar desconta gemas, veste e não deixa comprar sem saldo', () {
    progresso.concluir(1, 3); // 25 gemas
    final laco = itemPorId('laco')!; // 15
    final coroa = itemPorId('coroa')!; // 120

    expect(perfil.comprar(coroa), isFalse);
    expect(perfil.comprou('coroa'), isFalse);

    expect(perfil.comprar(laco), isTrue);
    expect(perfil.gemas, 10);
    expect(perfil.acessorio, 'laco');
    expect(perfil.totalCompradas, 1);

    // Tocar de novo no acessório tira ele
    perfil.vestir(laco);
    expect(perfil.acessorio, isNull);
  });

  test('não veste peça que não foi comprada', () {
    perfil.vestir(itemPorId('vestido')!);
    expect(perfil.roupa, roupaInicial);
  });

  testWidgets('todos os avatares e roupinhas desenham sem erro', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Wrap(children: [
        for (final base in avatares)
          for (final item in itensDaLoja)
            AvatarDesenho(
              base: base,
              roupa: item.tipo == TipoItem.roupa ? item : null,
              acessorio: item.tipo == TipoItem.acessorio ? item : null,
              tamanho: 20,
            ),
      ]),
    ));
    expect(tester.takeException(), isNull);
  });

  testWidgets('perfil e loja abrem', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Perfil()));
    expect(find.text('Editar perfil'), findsOneWidget);
    expect(find.textContaining('Conquistas (0 de'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: Loja()));
    expect(find.text('Loja de roupinhas'), findsOneWidget);
    expect(find.text('USANDO'), findsOneWidget);
  });
}
