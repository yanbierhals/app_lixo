import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Pontuacao extends StatefulWidget {
  const Pontuacao({super.key});

  @override
  _PontuacaoState createState() => _PontuacaoState();
}

class _PontuacaoState extends State<Pontuacao> {
  int pontuacaoAtual = 20;

  @override
  Widget build(BuildContext context) {
    double progresso = (pontuacaoAtual / 150).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pontuação'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 13.0,
                  percent: progresso,
                  center: Text(
                    '$pontuacaoAtual',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.green,
                  circularStrokeCap: CircularStrokeCap.round,
                  arcType: ArcType.HALF,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      pontuacaoAtual++; // Incrementa a pontuação
                    });
                  },
                  child: const Text('Incrementar Pontuação'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Voltar"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
