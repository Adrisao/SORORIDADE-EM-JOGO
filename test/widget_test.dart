import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app/app.dart';

void main() {
  testWidgets('Trilha abre com a primeira lição liberada', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Sororidade em Jogo'), findsOneWidget);
    expect(find.text('Bem-vinda à trilha!'), findsOneWidget);
    expect(find.text('COMEÇAR'), findsOneWidget);
  });
}
