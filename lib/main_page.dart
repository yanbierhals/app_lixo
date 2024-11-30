import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';  // Importa a biblioteca para controle de tempo

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String qrCodeData = "Nenhum código lido";
  bool isPostSent = false;  // Variável para controlar se o POST já foi enviado
  bool isScanning = true;    // Variável para controlar se o scanner está ativo
  bool isSending = false;    // Variável para controlar se a requisição POST está sendo enviada

  // Método para enviar os dados via POST
  Future<void> sendQRCodeData(String idLixeira) async {
    // Impede múltiplas requisições rápidas
    if (isSending) return; // Verifica se já está enviando, se sim, não faz mais nada

    setState(() {
      isSending = true;  // Inicia o envio da requisição
    });

    final url = Uri.parse('https://api-lixo.onrender.com/api/leituras/inserir');

    // Corpo da requisição
    final body = jsonEncode({
      "id_usuario": 12, // Exemplo de id_usuario, pode ser alterado conforme necessário
      "id_lixeira": idLixeira,
    });

    // Cabeçalhos da requisição
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      // Enviando a requisição POST
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Verifica se a requisição foi bem-sucedida
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Dados enviados com sucesso!');
        // Exibe a notificação de sucesso
        showSuccessNotification();
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    } finally {
      // Após 2 segundos, permite uma nova leitura
      await Future.delayed(Duration(seconds: 2)); // Intervalo de 2 segundos
      setState(() {
        isSending = false;  // Permite enviar outra requisição
      });
    }
  }

  // Método para exibir a notificação de sucesso
  void showSuccessNotification() {
    setState(() {
      isPostSent = true;  // Marca que o POST foi enviado
      isScanning = false; // Desativa o scanner após a leitura
    });

    // Exibe a notificação de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lixeira lida com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leitor de QR Code')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Minha Pontuação'),
              onTap: () {
                Navigator.pushNamed(context, '/Pontuacao');
              },
            ),
            ListTile(
              title: Text('Passo a Passo'),
              onTap: () {
                Navigator.pushNamed(context, '/Passo');
              },
            ),
            ListTile(
              title: Text('Ajuda'),
              onTap: () {
                Navigator.pushNamed(context, '/Help');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibe o scanner de QR Code apenas se o POST ainda não foi enviado
            if (isScanning)
              SizedBox(
                width: 300,
                height: 300,
                child: MobileScanner(
                  onDetect: (BarcodeCapture barcodeCapture) {
                    if (!isPostSent && !isSending) {
                      final barcode = barcodeCapture.barcodes.first; // Obtém o primeiro código de barras detectado
                      if (barcode.rawValue != null) {
                        setState(() {
                          qrCodeData = barcode.rawValue!;
                        });
                        // Chama o método para enviar os dados via POST
                        sendQRCodeData(qrCodeData);
                      }
                    }
                  },
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Conteúdo do QR Code:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              qrCodeData,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}