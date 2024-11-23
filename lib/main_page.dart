import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa as câmeras disponíveis
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
  }

  // Solicita permissão para a câmera e abre a câmera
  Future<void> _requestCameraPermissionAndOpen() async {
    final status = await Permission.camera.request();
    print(status.isGranted);
    if (status.isGranted) {
      _openCamera();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  // Abre a câmera
  void _openCamera() {
    if (cameras != null && cameras!.isNotEmpty) {
      // Inicializa o controlador da câmera com a primeira câmera disponível
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  // Exibe o diálogo quando a permissão é negada
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
            // Exibe a visualização da câmera se o controlador estiver inicializado
            if (_cameraController != null && _cameraController!.value.isInitialized)
              SizedBox(
                width: 300,
                height: 300,
                child: CameraPreview(_cameraController!), // Exibe o preview da câmera
              )
            else
              Text('Aguardando a inicialização da câmera...'), // Exibe mensagem de carregamento

            SizedBox(height: 20),

            // Botão para solicitar permissão e abrir a câmera
            ElevatedButton(
              onPressed: () async {
                // Chama a função para solicitar permissão e abrir a câmera
                await _requestCameraPermissionAndOpen();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Image.asset(
                'assets/ScanMe.png', // Imagem no assets
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
    // Libera o controlador da câmera ao sair da tela
    _cameraController?.dispose();
    super.dispose();
  }
}
