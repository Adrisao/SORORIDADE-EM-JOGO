
import 'package:flutter/material.dart';

// Paleta de cores do Empodera Solidário.
// Todas as telas devem usar as cores daqui, nunca um Color(...) solto.
class Pallet {
  Pallet._();

  // Paleta principal
  static const Color rosaMagenta = Color(0xFFD1398C); // barra do topo, botões, cards
  static const Color roxoAmeixa = Color(0xFF6D2E6A); // faixa "Bem-vinda", títulos, logo
  static const Color verdeAgua = Color(0xFF43B0A2); // links e destaques
  static const Color verdeAguaClaro = Color(0xFFC3E3DB); // pílulas
  static const Color creme = Color(0xFFF4EFDE); // fundo da página

  // Cores de apoio
  static const Color lavanda = Color(0xFFE7DAF1); // fundos suaves
  static const Color roxoLogo = Color(0xFF8E5CA6); // círculo do logo
  static const Color textoEscuro = Color(0xFF3A2E39); // textos em geral
  static const Color branco = Color(0xFFFFFFFF); // texto sobre rosa/roxo, cartões
  static const Color preto = Color(0xFF000000); // fundo do vídeo em tela cheia

  // Gemas (moeda da loja)
  static const Color gema = Color(0xFF2FA4D8);

  // Tons de pele dos avatares
  static const Color peleClara = Color(0xFFFBE0CF);
  static const Color pelePessego = Color(0xFFF2C6A0);
  static const Color peleMorena = Color(0xFFD9A06B);
  static const Color peleParda = Color(0xFFB97A4E);
  static const Color peleMarrom = Color(0xFF8D5535);
  static const Color peleEscura = Color(0xFF5E3622);

  // Cores de cabelo dos avatares
  static const Color cabeloPreto = Color(0xFF2B1D1A);
  static const Color cabeloCastanho = Color(0xFF6B3E26);
  static const Color cabeloRuivo = Color(0xFFC4572A);
  static const Color cabeloLoiro = Color(0xFFE8C26A);
  static const Color cabeloRoxo = Color(0xFF7A4FB3);
  static const Color cabeloRosa = Color(0xFFF08DBE);

  // Cores extras das roupinhas
  static const Color amareloSol = Color(0xFFF6C443);
  static const Color azulCeu = Color(0xFF6FB7E9);
  static const Color vermelhoCoral = Color(0xFFEF6F5E);
  static const Color dourado = Color(0xFFE5B12E);
  static const Color cinzaGrafite = Color(0xFF4A4550);
  static const Color azulJeans = Color(0xFF4F78B8);
  static const Color verdeFolha = Color(0xFF5DAE6B);
  static const Color rosaClaro = Color(0xFFF7B7D6);
  static const Color lilasBrilho = Color(0xFFC9A6F2);

  // Fonte usada em todo o app
  static const String fonte = 'Quicksand';
}
