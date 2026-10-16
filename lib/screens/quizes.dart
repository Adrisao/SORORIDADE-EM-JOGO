
import 'package:flutter/material.dart';

class Quizes extends StatelessWidget {
  const Quizes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizes'),
      ),
      body: const Center(
        child: Text(
          'Escolha um quiz para começar!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
