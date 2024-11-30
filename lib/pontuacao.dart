import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'leituras_service.dart';

class Pontuacao extends StatefulWidget {
  const Pontuacao({super.key});

  @override
  _PontuacaoState createState() => _PontuacaoState();
}

class _PontuacaoState extends State<Pontuacao> {
  int pontuacaoAtual = 0;
  final LeiturasService _leiturasService = LeiturasService();

  @override
  void initState() {
    super.initState();
    _loadLeituras();  // Chama a função para carregar as leituras assim que o widget for inicializado
  }

  // Função para carregar as leituras e atualizar a pontuação
  Future<void> _loadLeituras() async {
    try {
      List<dynamic> leituras = await _leiturasService.listarLeituras();
      print("Leituras carregadas: $leituras");  // Verifique o que está sendo retornado
      setState(() {
        pontuacaoAtual = leituras.length;  // Atualiza a pontuação com o número de leituras
      });
    } catch (e) {
      print('Erro ao carregar leituras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double progresso = (pontuacaoAtual / 100).clamp(0.0, 1.0);  // Limita o valor entre 0 e 1

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
                )
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