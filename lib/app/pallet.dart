
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

  // Fonte usada em todo o app
  static const String fonte = 'Quicksand';
}
