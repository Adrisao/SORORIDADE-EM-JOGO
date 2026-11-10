import 'dart:math';

import 'package:flutter/material.dart';

import '../app/pallet.dart';
import '../app/perfil_aluna.dart';
import '../data/avatares.dart';

// Avatar redondo desenhado em código: menina + roupa + acessório.
class AvatarDesenho extends StatelessWidget {
  final AvatarBase base;
  final ItemLoja? roupa;
  final ItemLoja? acessorio;
  final double tamanho;
  final Color fundo;
  final Color? borda;

  const AvatarDesenho({
    super.key,
    required this.base,
    this.roupa,
    this.acessorio,
    this.tamanho = 96,
    this.fundo = Pallet.lavanda,
    this.borda,
  });

  @override
  Widget build(BuildContext context) {
    final larguraBorda = borda == null ? 0.0 : tamanho * 0.04;
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        color: fundo,
        shape: BoxShape.circle,
        border: borda == null ? null : Border.all(color: borda!, width: larguraBorda),
      ),
      child: ClipOval(
        child: CustomPaint(
          painter: _PintorAvatar(
            base: base,
            roupa: roupa ?? itemPorId(roupaInicial)!,
            acessorio: acessorio,
          ),
        ),
      ),
    );
  }
}

// Avatar da aluna logada; se redesenha quando ela troca de roupa.
class AvatarDaAluna extends StatelessWidget {
  final double tamanho;
  final Color fundo;
  final Color? borda;

  const AvatarDaAluna({
    super.key,
    this.tamanho = 96,
    this.fundo = Pallet.lavanda,
    this.borda,
  });

  @override
  Widget build(BuildContext context) {
    final perfil = PerfilAluna.instancia;
    return ListenableBuilder(
      listenable: perfil,
      builder: (context, _) => AvatarDesenho(
        base: avatarPorId(perfil.avatar),
        roupa: itemPorId(perfil.roupa),
        acessorio: itemPorId(perfil.acessorio),
        tamanho: tamanho,
        fundo: fundo,
        borda: borda,
      ),
    );
  }
}

// Tudo é desenhado num quadrado de 100 x 100 e depois ampliado.
// Ordem: capa, cabelo de trás, corpo e roupa, mechas da frente,
// rosto, franja e, por último, o acessório.
class _PintorAvatar extends CustomPainter {
  final AvatarBase base;
  final ItemLoja roupa;
  final ItemLoja? acessorio;

  _PintorAvatar({required this.base, required this.roupa, this.acessorio});

  Paint _tinta(Color cor) => Paint()
    ..color = cor
    ..isAntiAlias = true;

  Paint _traco(Color cor, double largura) => Paint()
    ..color = cor
    ..style = PaintingStyle.stroke
    ..strokeWidth = largura
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  Color _escurecer(Color cor, [double quanto = 0.25]) =>
      Color.lerp(cor, Pallet.preto, quanto)!;

  Color _clarear(Color cor, [double quanto = 0.35]) =>
      Color.lerp(cor, Pallet.branco, quanto)!;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    // Diminui um pouco a menina para caber mais da roupa no círculo.
    canvas.translate(50, 3);
    canvas.scale(0.9);
    canvas.translate(-50, 0);

    if (roupa.estilo == Estilo.heroina) _capa(canvas);
    _cabeloDeTras(canvas);
    if (roupa.estilo == Estilo.heroina) _golaDaCapa(canvas);
    _pescoco(canvas);
    _roupa(canvas);
    _mechasDaFrente(canvas);
    _rosto(canvas);
    _franja(canvas);
    _acessorio(canvas);

    canvas.restore();
  }

  // =================== CABELO ===================

  Paint get _cabelo => _tinta(base.cabelo);

  void _cabeloDeTras(Canvas canvas) {
    final cabelo = _cabelo;
    final sombra = _tinta(_escurecer(base.cabelo, 0.18));

    switch (base.penteado) {
      case Penteado.longo:
      case Penteado.ondulado:
        canvas.drawRRect(
          RRect.fromLTRBR(23, 14, 77, 96, const Radius.circular(26)),
          cabelo,
        );
        // Sombra do cabelo atrás do pescoço
        canvas.drawRRect(
          RRect.fromLTRBR(34, 50, 66, 90, const Radius.circular(12)),
          sombra,
        );
      case Penteado.cacheado:
        canvas.drawCircle(const Offset(50, 38), 30, cabelo);
        for (var i = 0; i < 14; i++) {
          final a = i * 2 * pi / 14;
          canvas.drawCircle(Offset(50 + cos(a) * 29, 40 + sin(a) * 27), 8, cabelo);
        }
      case Penteado.puff:
        canvas.drawCircle(const Offset(50, 11), 15, cabelo);
        for (var i = 0; i < 9; i++) {
          final a = pi + i * pi / 8;
          canvas.drawCircle(Offset(50 + cos(a) * 14, 12 + sin(a) * 12), 5.5, cabelo);
        }
        canvas.drawCircle(const Offset(45, 7), 3, _tinta(_clarear(base.cabelo, 0.2)));
      case Penteado.coques:
        for (final x in [30.0, 70.0]) {
          canvas.drawCircle(Offset(x, 15), 10.5, cabelo);
          canvas.drawArc(
            Rect.fromCircle(center: Offset(x, 15), radius: 6),
            0.2 * pi,
            1.3 * pi,
            false,
            _traco(_escurecer(base.cabelo), 1.4),
          );
        }
      case Penteado.rabo:
        final rabo = Path()
          ..moveTo(60, 14)
          ..cubicTo(90, 8, 94, 46, 82, 78)
          ..cubicTo(80, 60, 76, 40, 62, 28)
          ..close();
        canvas.drawPath(rabo, cabelo);
        canvas.drawPath(
          Path()
            ..moveTo(78, 30)
            ..quadraticBezierTo(86, 50, 82, 70),
          _traco(_escurecer(base.cabelo), 1.3),
        );
      case Penteado.curto:
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            24, 13, 76, 64,
            topLeft: const Radius.circular(26),
            topRight: const Radius.circular(26),
            bottomLeft: const Radius.circular(6),
            bottomRight: const Radius.circular(6),
          ),
          cabelo,
        );
      case Penteado.trancas:
        break; // as tranças ficam na frente do corpo
    }
  }

  // Mechas que caem na frente dos ombros (desenhadas por cima da roupa)
  void _mechasDaFrente(Canvas canvas) {
    final cabelo = _cabelo;
    final linha = _traco(_escurecer(base.cabelo), 1.1);

    switch (base.penteado) {
      case Penteado.longo:
        for (final lado in [-1.0, 1.0]) {
          final mecha = Path()
            ..moveTo(50 + lado * 21, 44)
            ..quadraticBezierTo(50 + lado * 25, 72, 50 + lado * 22, 96)
            ..lineTo(50 + lado * 13, 96)
            ..quadraticBezierTo(50 + lado * 15, 72, 50 + lado * 14, 54)
            ..close();
          canvas.drawPath(mecha, cabelo);
          canvas.drawPath(
            Path()
              ..moveTo(50 + lado * 19, 60)
              ..quadraticBezierTo(50 + lado * 20, 78, 50 + lado * 18, 94),
            linha,
          );
        }
      case Penteado.ondulado:
        for (final lado in [-1.0, 1.0]) {
          double x(double v) => 50 + lado * v;
          final mecha = Path()
            ..moveTo(x(21), 44)
            ..cubicTo(x(28), 56, x(19), 64, x(25), 74)
            ..cubicTo(x(30), 82, x(22), 90, x(24), 98)
            ..lineTo(x(13), 98)
            ..cubicTo(x(12), 90, x(19), 84, x(15), 74)
            ..cubicTo(x(11), 66, x(18), 60, x(14), 52)
            ..close();
          canvas.drawPath(mecha, cabelo);
          canvas.drawPath(
            Path()
              ..moveTo(x(19), 58)
              ..cubicTo(x(23), 66, x(17), 74, x(20), 84),
            linha,
          );
        }
      case Penteado.trancas:
        for (final lado in [-1.0, 1.0]) {
          final x = 50 + lado * 20.5;
          for (var i = 0; i < 7; i++) {
            final c = Offset(x - lado * i * 0.5, 50 + i * 6.2);
            canvas.drawOval(Rect.fromCenter(center: c, width: 10, height: 8), cabelo);
            canvas.drawArc(
              Rect.fromCenter(center: c, width: 8, height: 6),
              0.15 * pi,
              0.7 * pi,
              false,
              linha,
            );
          }
          final ponta = Offset(x - lado * 3.5, 95);
          canvas.drawCircle(ponta.translate(0, -3), 2.8, _tinta(Pallet.verdeAgua));
          canvas.drawPath(
            Path()
              ..moveTo(ponta.dx - 3, ponta.dy - 1)
              ..lineTo(ponta.dx, ponta.dy + 6)
              ..lineTo(ponta.dx + 3, ponta.dy - 1)
              ..close(),
            cabelo,
          );
        }
      default:
        break;
    }
  }

  // Franja: cobre o topo da cabeça, sempre acima da testa
  // (assim nenhuma personagem fica "careca").
  void _franja(Canvas canvas) {
    final cabelo = _cabelo;
    final ladoY = base.penteado == Penteado.curto ? 64.0 : 54.0;

    final topo = Path()
      ..moveTo(28.5, ladoY)
      ..cubicTo(20, 24, 35, 10, 50, 10)
      ..cubicTo(65, 10, 80, 24, 71.5, ladoY);

    // Linha de baixo da franja, que muda conforme o penteado
    switch (base.penteado) {
      case Penteado.curto:
        // Franja reta
        topo
          ..quadraticBezierTo(70, 40, 66, 33)
          ..lineTo(34, 33)
          ..quadraticBezierTo(30, 40, 28.5, ladoY);
      case Penteado.trancas:
      case Penteado.coques:
      case Penteado.longo:
        // Repartido no meio
        topo
          ..quadraticBezierTo(70, 36, 60, 29)
          ..quadraticBezierTo(53, 25, 50, 21)
          ..quadraticBezierTo(47, 25, 40, 29)
          ..quadraticBezierTo(30, 36, 28.5, ladoY);
      case Penteado.puff:
        // Penteado para trás
        topo
          ..quadraticBezierTo(70, 31, 60, 25)
          ..quadraticBezierTo(50, 22, 40, 25)
          ..quadraticBezierTo(30, 31, 28.5, ladoY);
      default:
        // Franja de lado
        topo
          ..quadraticBezierTo(70, 40, 64, 33)
          ..quadraticBezierTo(57, 38, 47, 30)
          ..quadraticBezierTo(41, 35, 36, 33)
          ..quadraticBezierTo(31, 38, 28.5, ladoY);
    }
    topo.close();
    canvas.drawPath(topo, cabelo);

    if (base.penteado == Penteado.cacheado) {
      // Cachinhos na testa e nas laterais
      for (var x = 33.0; x <= 67; x += 5.6) {
        canvas.drawCircle(Offset(x, 29 + (x - 50).abs() * 0.12), 5, cabelo);
      }
      for (final p in const [Offset(29, 40), Offset(71, 40), Offset(28, 50), Offset(72, 50)]) {
        canvas.drawCircle(p, 5, cabelo);
      }
    }

    if (base.penteado == Penteado.puff) {
      // Elástico do coque
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(50, 21), width: 16, height: 5),
        _tinta(Pallet.amareloSol),
      );
    }
    if (base.penteado == Penteado.rabo) {
      canvas.drawCircle(const Offset(63, 15), 4, _tinta(Pallet.rosaMagenta));
    }
    if (base.penteado == Penteado.coques) {
      canvas.drawCircle(const Offset(36, 18), 2.6, _tinta(Pallet.rosaMagenta));
      canvas.drawCircle(const Offset(64, 18), 2.6, _tinta(Pallet.rosaMagenta));
    }

    // Brilho do cabelo
    canvas.drawArc(
      const Rect.fromLTRB(33, 14, 67, 44),
      1.12 * pi,
      0.3 * pi,
      false,
      _traco(Pallet.branco.withValues(alpha: 0.22), 3),
    );
  }

  // =================== ROSTO ===================

  void _pescoco(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTRB(44.5, 56, 55.5, 80), _tinta(base.pele));
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 63), width: 12, height: 7),
      _tinta(_escurecer(base.pele, 0.15)),
    );
  }

  void _rosto(Canvas canvas) {
    final pele = _tinta(base.pele);
    canvas.drawOval(const Rect.fromLTRB(31, 21, 69, 65), pele);

    // Sobrancelhas
    final sobrancelha = _traco(_escurecer(base.cabelo, 0.15), 1.6);
    canvas.drawArc(Rect.fromCenter(center: const Offset(42, 39), width: 8, height: 4),
        1.15 * pi, 0.7 * pi, false, sobrancelha);
    canvas.drawArc(Rect.fromCenter(center: const Offset(58, 39), width: 8, height: 4),
        1.15 * pi, 0.7 * pi, false, sobrancelha);

    // Olhos grandes com brilho e cílios
    final olho = _tinta(Pallet.textoEscuro);
    final brilho = _tinta(Pallet.branco);
    final cilio = _traco(Pallet.textoEscuro, 1.3);
    for (final lado in [-1.0, 1.0]) {
      final x = 50 + lado * 8;
      canvas.drawOval(Rect.fromCenter(center: Offset(x, 46), width: 6.6, height: 8.2), olho);
      canvas.drawCircle(Offset(x + 1.3, 44.2), 1.6, brilho);
      canvas.drawCircle(Offset(x - 1.2, 48.2), 0.7, brilho);
      canvas.drawLine(Offset(x + lado * 3, 43.4), Offset(x + lado * 5.2, 41.6), cilio);
      canvas.drawLine(Offset(x + lado * 2, 42.4), Offset(x + lado * 3.6, 40.4), cilio);
    }

    // Bochechas
    final bochecha = _tinta(Pallet.rosaMagenta.withValues(alpha: 0.25));
    canvas.drawOval(Rect.fromCenter(center: const Offset(36.5, 53), width: 7.5, height: 4.2), bochecha);
    canvas.drawOval(Rect.fromCenter(center: const Offset(63.5, 53), width: 7.5, height: 4.2), bochecha);

    // Nariz
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(50, 51), width: 3.4, height: 2.4),
      0.1 * pi,
      0.8 * pi,
      false,
      _traco(_escurecer(base.pele, 0.3), 1.1),
    );

    // Sorriso aberto
    final boca = Path()
      ..moveTo(45.5, 55)
      ..quadraticBezierTo(50, 61.5, 54.5, 55)
      ..quadraticBezierTo(50, 56.4, 45.5, 55)
      ..close();
    canvas.drawPath(boca, _tinta(Color.lerp(Pallet.rosaMagenta, Pallet.roxoAmeixa, 0.55)!));
  }

  // =================== ROUPAS ===================

  Path get _tronco => Path()
    ..moveTo(9, 114)
    ..lineTo(12, 90)
    ..quadraticBezierTo(14, 75, 31, 72.5)
    ..lineTo(69, 72.5)
    ..quadraticBezierTo(86, 75, 88, 90)
    ..lineTo(91, 114)
    ..close();

  void _capa(Canvas canvas) {
    final capa = Path()
      ..moveTo(22, 74)
      ..lineTo(2, 114)
      ..lineTo(98, 114)
      ..lineTo(78, 74)
      ..close();
    canvas.drawPath(capa, _tinta(roupa.detalhe));
  }

  // Gola alta da capa, atrás do pescoço
  void _golaDaCapa(Canvas canvas) {
    final gola = _tinta(roupa.detalhe);
    for (final lado in [-1.0, 1.0]) {
      canvas.drawPath(
        Path()
          ..moveTo(50 + lado * 4, 74)
          ..lineTo(50 + lado * 21, 56)
          ..quadraticBezierTo(50 + lado * 22, 68, 50 + lado * 24, 76)
          ..close(),
        gola,
      );
    }
  }

  void _roupa(Canvas canvas) {
    final cor = _tinta(roupa.cor);
    final detalhe = _tinta(roupa.detalhe);
    final dobra = _traco(_escurecer(roupa.cor, 0.15), 1.2);

    if (roupa.estilo == Estilo.moletom) {
      // Capuz atrás do pescoço
      canvas.drawOval(const Rect.fromLTRB(28, 66, 72, 84), _tinta(_escurecer(roupa.cor, 0.12)));
    }

    canvas.drawPath(_tronco, cor);

    canvas.save();
    canvas.clipPath(_tronco);

    switch (roupa.estilo) {
      case Estilo.listrada:
        for (var y = 79.0; y < 114; y += 7) {
          canvas.drawRect(Rect.fromLTRB(0, y, 100, y + 3.2), detalhe);
        }
      case Estilo.coracao:
        canvas.drawPath(_coracao(const Offset(50, 89), 7.5), detalhe);
        canvas.drawCircle(const Offset(47, 86), 1.3, _tinta(Pallet.branco.withValues(alpha: 0.6)));
      case Estilo.estrela:
        canvas.drawPath(_estrela(const Offset(50, 89), 8.5, 3.6), detalhe);
        canvas.drawCircle(const Offset(36, 82), 1.2, detalhe);
        canvas.drawCircle(const Offset(64, 95), 1.2, detalhe);
      case Estilo.arcoIris:
        final cores = [Pallet.vermelhoCoral, Pallet.amareloSol, Pallet.verdeAgua, Pallet.azulCeu];
        for (var i = 0; i < cores.length; i++) {
          final r = 18.0 - i * 4;
          canvas.drawArc(
            Rect.fromCircle(center: const Offset(50, 100), radius: r),
            pi,
            pi,
            false,
            Paint()
              ..color = cores[i]
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4,
          );
        }
        // Nuvenzinhas
        for (final x in [33.0, 67.0]) {
          canvas.drawCircle(Offset(x, 99), 3.5, _tinta(Pallet.lavanda));
          canvas.drawCircle(Offset(x + 3.5, 98), 3, _tinta(Pallet.lavanda));
          canvas.drawCircle(Offset(x - 3.5, 99.5), 2.6, _tinta(Pallet.lavanda));
        }
      case Estilo.time:
        // Faixas nas mangas e número 10
        canvas.drawLine(const Offset(18, 78), const Offset(14, 114), _traco(roupa.detalhe, 3));
        canvas.drawLine(const Offset(82, 78), const Offset(86, 114), _traco(roupa.detalhe, 3));
        final numero = TextPainter(
          text: TextSpan(
            text: '10',
            style: TextStyle(
              color: roupa.detalhe,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontFamily: Pallet.fonte,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        numero.paint(canvas, Offset(50 - numero.width / 2, 82));
      case Estilo.vestido:
        // Cintura e brilhinhos
        canvas.drawRect(const Rect.fromLTRB(0, 96, 100, 100), _tinta(_escurecer(roupa.cor, 0.15)));
        for (final p in const [Offset(30, 84), Offset(70, 86), Offset(40, 93), Offset(62, 92), Offset(22, 94), Offset(78, 96)]) {
          canvas.drawPath(_estrela(p, 2.2, 0.9), detalhe);
        }
      case Estilo.moletom:
        final cordao = _traco(roupa.detalhe, 1.5);
        canvas.drawLine(const Offset(46, 78), const Offset(45, 90), cordao);
        canvas.drawLine(const Offset(54, 78), const Offset(55, 90), cordao);
        canvas.drawCircle(const Offset(45, 90.5), 1.3, detalhe);
        canvas.drawCircle(const Offset(55, 90.5), 1.3, detalhe);
        canvas.drawRRect(
          RRect.fromLTRBR(35, 95, 65, 112, const Radius.circular(5)),
          _tinta(_escurecer(roupa.cor, 0.1)),
        );
      case Estilo.jaqueta:
        // Blusa por baixo, golas e botões da jaqueta jeans
        canvas.drawPath(
          Path()
            ..moveTo(40, 72)
            ..lineTo(60, 72)
            ..lineTo(57, 114)
            ..lineTo(43, 114)
            ..close(),
          detalhe,
        );
        canvas.drawPath(_coracao(const Offset(50, 90), 3.5), _tinta(Pallet.rosaMagenta));
        final gola = _tinta(_escurecer(roupa.cor, 0.18));
        canvas.drawPath(
          Path()
            ..moveTo(40, 72)
            ..lineTo(32, 76)
            ..lineTo(42, 86)
            ..close(),
          gola,
        );
        canvas.drawPath(
          Path()
            ..moveTo(60, 72)
            ..lineTo(68, 76)
            ..lineTo(58, 86)
            ..close(),
          gola,
        );
        final costura = _traco(Pallet.amareloSol.withValues(alpha: 0.8), 0.8);
        canvas.drawLine(const Offset(42, 86), const Offset(43, 114), costura);
        canvas.drawLine(const Offset(58, 86), const Offset(57, 114), costura);
        canvas.drawRRect(RRect.fromLTRBR(26, 86, 36, 93, const Radius.circular(1.5)), gola);
        canvas.drawRRect(RRect.fromLTRBR(64, 86, 74, 93, const Radius.circular(1.5)), gola);
        canvas.drawCircle(const Offset(31, 88), 0.9, _tinta(Pallet.dourado));
        canvas.drawCircle(const Offset(69, 88), 0.9, _tinta(Pallet.dourado));
      case Estilo.macacao:
        canvas.drawRect(const Rect.fromLTRB(0, 70, 100, 114), detalhe);
        canvas.drawRRect(RRect.fromLTRBR(35, 86, 65, 114, const Radius.circular(3)), cor);
        canvas.drawRect(const Rect.fromLTRB(0, 97, 100, 114), cor);
        final alca = _traco(roupa.cor, 5);
        canvas.drawLine(const Offset(37, 73), const Offset(38, 88), alca);
        canvas.drawLine(const Offset(63, 73), const Offset(62, 88), alca);
        canvas.drawCircle(const Offset(38.5, 88.5), 2, _tinta(Pallet.amareloSol));
        canvas.drawCircle(const Offset(61.5, 88.5), 2, _tinta(Pallet.amareloSol));
        canvas.drawRRect(
          RRect.fromLTRBR(44, 90, 56, 97, const Radius.circular(2)),
          _tinta(_escurecer(roupa.cor, 0.12)),
        );
      case Estilo.princesa:
        // Corpete com renda e joia
        canvas.drawPath(
          Path()
            ..moveTo(36, 80)
            ..quadraticBezierTo(43, 86, 50, 82)
            ..quadraticBezierTo(57, 86, 64, 80)
            ..lineTo(62, 114)
            ..lineTo(38, 114)
            ..close(),
          _tinta(_escurecer(roupa.cor, 0.1)),
        );
        for (var x = 37.0; x <= 63; x += 4.3) {
          canvas.drawCircle(Offset(x, 80 + (x - 50).abs() * 0.05), 1.6, _tinta(Pallet.branco));
        }
        for (final p in const [Offset(28, 92), Offset(72, 90), Offset(44, 96), Offset(57, 98)]) {
          canvas.drawPath(_estrela(p, 2, 0.8), _tinta(Pallet.branco));
        }
      case Estilo.heroina:
        canvas.drawRect(const Rect.fromLTRB(0, 96, 100, 100), _tinta(Pallet.amareloSol));
        canvas.drawCircle(const Offset(50, 87), 8, _tinta(Pallet.amareloSol));
        canvas.drawPath(
          Path()
            ..moveTo(52, 80.5)
            ..lineTo(46, 88)
            ..lineTo(50, 88)
            ..lineTo(48, 93.5)
            ..lineTo(54, 86)
            ..lineTo(50, 86)
            ..close(),
          cor,
        );
      default:
        break;
    }

    // Dobras das mangas
    canvas.drawPath(
      Path()
        ..moveTo(23, 76)
        ..quadraticBezierTo(27, 88, 24, 114),
      dobra,
    );
    canvas.drawPath(
      Path()
        ..moveTo(77, 76)
        ..quadraticBezierTo(73, 88, 76, 114),
      dobra,
    );
    canvas.restore();

    // Decote
    final pele = _tinta(base.pele);
    if (roupa.estilo == Estilo.time) {
      final v = Path()
        ..moveTo(43, 72)
        ..lineTo(50, 81)
        ..lineTo(57, 72)
        ..close();
      canvas.drawPath(v, pele);
      canvas.drawPath(
        Path()
          ..moveTo(42, 72)
          ..lineTo(50, 82)
          ..lineTo(58, 72),
        _traco(roupa.detalhe, 2),
      );
    } else if (roupa.estilo != Estilo.jaqueta) {
      canvas.drawPath(
        Path()
          ..moveTo(42.5, 72)
          ..quadraticBezierTo(50, 82, 57.5, 72)
          ..close(),
        pele,
      );
    }

    switch (roupa.estilo) {
      case Estilo.vestido:
        // Golinha
        canvas.drawOval(const Rect.fromLTRB(36, 72, 50, 81), detalhe);
        canvas.drawOval(const Rect.fromLTRB(50, 72, 64, 81), detalhe);
        canvas.drawCircle(const Offset(50, 80), 2, _tinta(_escurecer(roupa.cor, 0.2)));
      case Estilo.princesa:
        // Mangas bufantes e colar
        final manga = _tinta(_clarear(roupa.cor, 0.25));
        canvas.drawCircle(const Offset(20, 82), 9, manga);
        canvas.drawCircle(const Offset(80, 82), 9, manga);
        canvas.drawArc(const Rect.fromLTRB(43, 66, 57, 80), 0.15 * pi, 0.7 * pi, false,
            _traco(Pallet.branco, 1.2));
        canvas.drawPath(
          Path()
            ..moveTo(50, 78)
            ..lineTo(52.3, 80.5)
            ..lineTo(50, 83)
            ..lineTo(47.7, 80.5)
            ..close(),
          detalhe,
        );
      case Estilo.heroina:
        // Presilhas da capa
        canvas.drawCircle(const Offset(31, 75), 2.4, _tinta(Pallet.amareloSol));
        canvas.drawCircle(const Offset(69, 75), 2.4, _tinta(Pallet.amareloSol));
      default:
        break;
    }
  }

  // =================== ACESSÓRIOS ===================

  void _acessorio(Canvas canvas) {
    final item = acessorio;
    if (item == null) return;
    final cor = _tinta(item.cor);
    final detalhe = _tinta(item.detalhe);

    switch (item.estilo) {
      case Estilo.laco:
        const c = Offset(68, 18);
        final escuro = _tinta(_escurecer(item.cor, 0.2));
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy)
            ..cubicTo(c.dx - 6, c.dy - 12, c.dx - 15, c.dy - 6, c.dx - 11, c.dy + 2)
            ..cubicTo(c.dx - 8, c.dy + 7, c.dx - 3, c.dy + 3, c.dx, c.dy)
            ..close(),
          cor,
        );
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy)
            ..cubicTo(c.dx + 6, c.dy - 12, c.dx + 15, c.dy - 6, c.dx + 11, c.dy + 2)
            ..cubicTo(c.dx + 8, c.dy + 7, c.dx + 3, c.dy + 3, c.dx, c.dy)
            ..close(),
          cor,
        );
        canvas.drawPath(
          Path()
            ..moveTo(c.dx - 1, c.dy + 1)
            ..lineTo(c.dx - 5, c.dy + 11)
            ..lineTo(c.dx - 1.5, c.dy + 9)
            ..close(),
          escuro,
        );
        canvas.drawPath(
          Path()
            ..moveTo(c.dx + 1, c.dy + 1)
            ..lineTo(c.dx + 5, c.dy + 11)
            ..lineTo(c.dx + 1.5, c.dy + 9)
            ..close(),
          escuro,
        );
        canvas.drawCircle(c, 3, escuro);
        canvas.drawCircle(c.translate(-7, -3), 1.2, _tinta(Pallet.branco.withValues(alpha: 0.6)));
      case Estilo.flor:
        _flor(canvas, const Offset(68, 21), 5, item.detalhe, item.cor);
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(60, 26), width: 7, height: 3.5),
          _tinta(Pallet.verdeFolha),
        );
      case Estilo.coroaFlores:
        for (final p in const [Offset(27, 32), Offset(73, 32)]) {
          canvas.drawOval(Rect.fromCenter(center: p, width: 6, height: 3.5), _tinta(Pallet.verdeFolha));
        }
        final flores = [
          (const Offset(30, 25), item.cor),
          (const Offset(38, 16), Pallet.lilasBrilho),
          (const Offset(50, 12), item.cor),
          (const Offset(62, 16), Pallet.lilasBrilho),
          (const Offset(70, 25), item.cor),
        ];
        for (final (p, c) in flores) {
          _flor(canvas, p, 3.3, c, item.detalhe);
        }
      case Estilo.oculos:
        final aro = _traco(item.cor, 1.8);
        for (final x in [42.0, 58.0]) {
          canvas.drawCircle(Offset(x, 46), 6.5, _tinta(Pallet.branco.withValues(alpha: 0.18)));
          canvas.drawCircle(Offset(x, 46), 6.5, aro);
        }
        canvas.drawArc(Rect.fromCenter(center: const Offset(50, 46), width: 3, height: 3),
            1.1 * pi, 0.8 * pi, false, aro);
      case Estilo.oculosCoracao:
        for (final x in [42.0, 58.0]) {
          canvas.drawPath(_coracao(Offset(x, 46), 6.8), cor);
          canvas.drawCircle(Offset(x - 2.2, 43.5), 1.4, _tinta(Pallet.branco.withValues(alpha: 0.6)));
        }
        canvas.drawLine(const Offset(48, 44), const Offset(52, 44), _traco(item.cor, 1.6));
      case Estilo.bone:
        final escuro = _tinta(_escurecer(item.cor, 0.2));
        canvas.drawOval(const Rect.fromLTRB(22, 27, 78, 37), escuro); // aba
        canvas.drawPath(
          Path()
            ..moveTo(26, 32)
            ..cubicTo(25, 5, 75, 5, 74, 32)
            ..close(),
          cor,
        );
        canvas.drawPath(
          Path()
            ..moveTo(50, 9.5)
            ..quadraticBezierTo(48, 20, 50, 31),
          _traco(_escurecer(item.cor, 0.15), 1),
        );
        canvas.drawCircle(const Offset(50, 10), 2, escuro);
        canvas.drawPath(_estrela(const Offset(40, 22), 4.5, 2), detalhe);
      case Estilo.orelhasGato:
        canvas.drawArc(const Rect.fromLTRB(26, 11, 74, 50), 1.08 * pi, 0.84 * pi, false,
            _traco(item.cor, 2.6));
        for (final lado in [-1.0, 1.0]) {
          double x(double v) => 50 + lado * v;
          canvas.drawPath(
            Path()
              ..moveTo(x(9), 15)
              ..lineTo(x(21), 3)
              ..lineTo(x(23), 21)
              ..close(),
            cor,
          );
          canvas.drawPath(
            Path()
              ..moveTo(x(12), 15)
              ..lineTo(x(19.5), 7.5)
              ..lineTo(x(20.5), 18)
              ..close(),
            detalhe,
          );
        }
      case Estilo.fone:
        canvas.drawArc(const Rect.fromLTRB(24, 7, 76, 60), pi, pi, false,
            _traco(item.detalhe, 4));
        for (final x in [26.0, 74.0]) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(x, 44), width: 11, height: 17),
              const Radius.circular(5),
            ),
            cor,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(x, 44), width: 5, height: 10),
              const Radius.circular(2.5),
            ),
            _tinta(_clarear(item.cor, 0.4)),
          );
        }
      case Estilo.tiara:
        canvas.drawArc(const Rect.fromLTRB(28, 12, 72, 50), 1.08 * pi, 0.84 * pi, false,
            _traco(item.detalhe, 2.4));
        for (final p in const [Offset(34, 20), Offset(42, 14.5), Offset(50, 12.5), Offset(58, 14.5), Offset(66, 20)]) {
          canvas.drawPath(_estrela(p, p.dx == 50 ? 5.5 : 3.8, p.dx == 50 ? 2.3 : 1.6), cor);
        }
      case Estilo.unicornio:
        canvas.drawArc(const Rect.fromLTRB(28, 12, 72, 50), 1.08 * pi, 0.84 * pi, false,
            _traco(item.detalhe, 2.4));
        // Orelhinhas
        for (final lado in [-1.0, 1.0]) {
          canvas.drawPath(
            Path()
              ..moveTo(50 + lado * 12, 14)
              ..quadraticBezierTo(50 + lado * 19, 3, 50 + lado * 20, 17)
              ..close(),
            _tinta(Pallet.branco),
          );
        }
        // Chifre com listras
        final chifre = Path()
          ..moveTo(44.5, 13)
          ..lineTo(50, -2)
          ..lineTo(55.5, 13)
          ..close();
        canvas.drawPath(chifre, cor);
        final listra = _traco(_clarear(item.cor, 0.5), 1);
        canvas.drawLine(const Offset(46.5, 9), const Offset(53.5, 7), listra);
        canvas.drawLine(const Offset(47.8, 4.5), const Offset(52.4, 3), listra);
        _flor(canvas, const Offset(38, 17), 3, item.detalhe, Pallet.amareloSol);
        _flor(canvas, const Offset(62, 17), 3, Pallet.lilasBrilho, Pallet.amareloSol);
      case Estilo.coroa:
        final coroa = Path()
          ..moveTo(35, 18)
          ..lineTo(34, 4)
          ..lineTo(42, 11)
          ..lineTo(50, 1)
          ..lineTo(58, 11)
          ..lineTo(66, 4)
          ..lineTo(65, 18)
          ..close();
        canvas.drawPath(coroa, cor);
        canvas.drawRect(const Rect.fromLTRB(35, 15, 65, 18.5), _tinta(_escurecer(item.cor, 0.15)));
        canvas.drawCircle(const Offset(50, 11), 2.6, detalhe);
        canvas.drawCircle(const Offset(41, 13), 1.7, _tinta(Pallet.verdeAgua));
        canvas.drawCircle(const Offset(59, 13), 1.7, _tinta(Pallet.verdeAgua));
        for (final p in const [Offset(34, 4), Offset(50, 1), Offset(66, 4)]) {
          canvas.drawCircle(p, 1.6, _tinta(_clarear(item.cor, 0.4)));
        }
      default:
        break;
    }
  }

  // =================== FORMAS ===================

  void _flor(Canvas canvas, Offset c, double r, Color petala, Color miolo) {
    for (var i = 0; i < 5; i++) {
      final a = i * 2 * pi / 5 - pi / 2;
      canvas.drawCircle(c + Offset(cos(a) * r, sin(a) * r), r * 0.85, _tinta(petala));
    }
    canvas.drawCircle(c, r * 0.65, _tinta(miolo));
  }

  Path _coracao(Offset c, double r) {
    return Path()
      ..moveTo(c.dx, c.dy + r)
      ..cubicTo(c.dx - r * 1.6, c.dy - r * 0.2, c.dx - r * 0.7, c.dy - r * 1.3, c.dx, c.dy - r * 0.45)
      ..cubicTo(c.dx + r * 0.7, c.dy - r * 1.3, c.dx + r * 1.6, c.dy - r * 0.2, c.dx, c.dy + r)
      ..close();
  }

  Path _estrela(Offset c, double externo, double interno) {
    final caminho = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? externo : interno;
      final a = -pi / 2 + i * pi / 5;
      final p = c + Offset(cos(a) * r, sin(a) * r);
      if (i == 0) {
        caminho.moveTo(p.dx, p.dy);
      } else {
        caminho.lineTo(p.dx, p.dy);
      }
    }
    return caminho..close();
  }

  @override
  bool shouldRepaint(_PintorAvatar antigo) =>
      antigo.base != base || antigo.roupa != roupa || antigo.acessorio != acessorio;
}

// Ícone de gema com o saldo, usado no topo das telas.
class SaldoDeGemas extends StatelessWidget {
  final int gemas;
  final Color cor;

  const SaldoDeGemas({super.key, required this.gemas, this.cor = Pallet.branco});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.diamond_rounded, color: cor, size: 22),
        const SizedBox(width: 4),
        Text(
          '$gemas',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: cor),
        ),
      ],
    );
  }
}
