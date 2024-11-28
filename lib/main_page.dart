import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importação para leitura de QR code

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Chave para o QR Scanner
  QRViewController? qrViewController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
  }

  Future<void> _requestCameraPermissionAndOpen() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openQRScanner();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _openQRScanner() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    qrViewController!.scannedDataStream.listen((scanData) {
      print('QR Code Lido: ${scanData.code}'); // Printa o QR code no terminal
      qrViewController?.dispose(); // Fecha o scanner após ler o QR
      Navigator.of(context).pop(); // Fecha o diálogo
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissão Negada'),
          content: Text('É necessário conceder a permissão para usar a câmera.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Principal')),
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
            if (_cameraController != null && _cameraController!.value.isInitialized)
              SizedBox(
                width: 300,
                height: 300,
                child: CameraPreview(_cameraController!),
              )
            else
              Text('Aguardando a inicialização da câmera...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _requestCameraPermissionAndOpen();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Image.asset(
                'assets/ScanMe.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    qrViewController?.dispose();
    super.dispose();
  }
}