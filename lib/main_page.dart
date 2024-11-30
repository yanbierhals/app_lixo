import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String qrCodeData = "Nenhum código lido";
  bool isPostSent = false;
  bool isScanning = true;
  bool isSending = false;

  Future<void> sendQRCodeData(String idLixeira) async {
    if (isSending) return;

    setState(() {
      isSending = true;
    });

    final url = Uri.parse('https://api-lixo.onrender.com/api/leituras/inserir');
    final body = jsonEncode({
      "id_usuario": 12,
      "id_lixeira": idLixeira,
    });
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Dados enviados com sucesso!');
        showSuccessNotification();
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    } finally {
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        isSending = false;
      });
    }
  }

  void showSuccessNotification() {
    setState(() {
      isPostSent = true;
      isScanning = false;
    });

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
        child: isScanning
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: MobileScanner(
                onDetect: (BarcodeCapture barcodeCapture) {
                  if (!isPostSent && !isSending) {
                    final barcode = barcodeCapture.barcodes.first;
                    if (barcode.rawValue != null) {
                      setState(() {
                        qrCodeData = barcode.rawValue!;
                      });
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
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scanner inativo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isScanning = true;
                  isPostSent = false;
                  qrCodeData = "Nenhum código lido";
                });
              },
              child: Text('Reabrir Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
