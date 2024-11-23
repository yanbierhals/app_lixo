import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem Vindo(a)!')),
      drawer: Drawer(
        child: ListView(
          children: [
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
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            'assets/ScanMe.png', //imagem de fundo aqui
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Bem-vindo ao App!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    _showLoginDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.cyan,
                  ),
                  child: const Text('Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // mostrar o pop-up de login
 void _showLoginDialog(BuildContext context) {
   final TextEditingController emailController = TextEditingController();
   final TextEditingController senhaController = TextEditingController();

   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Login'),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(
               controller: emailController,
               decoration: const InputDecoration(labelText: 'Email'),
             ),
             TextField(
               controller: senhaController,
               decoration: const InputDecoration(labelText: 'Senha'),
               obscureText: true,
             ),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () {
               Navigator.pop(context);
             },
             child: const Text('Cancelar'),
           ),
           TextButton(
             onPressed: () async {
               final email = emailController.text.trim();
               final senha = senhaController.text.trim();

               // Validar campos
               if (email.isEmpty || senha.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Preencha todos os campos.')),
                 );
                 return;
               }

               // Chamar API de login
               final response = await _login(email, senha);
               print(response);
               if (response != null && response['token'] != null) {
                 // Login bem-sucedido
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Login realizado com sucesso!')),
                 );

                 Navigator.pop(context); // Fechar o diálogo
                 Navigator.pushNamed(context, '/Main'); // Ir para a página principal
               } else {
                 // Erro no login
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Email ou senha inválidos.')),
                 );
               }

             },
             child: const Text('Entrar'),
           ),
         ],
       );
     },
   );
 }

  Future<Map<String, dynamic>?> _login(String email, String senha) async {
    final url = Uri.parse('https://api-lixo.onrender.com/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decodifica a resposta JSON
        return jsonDecode(response.body);
      } else {
        // Lida com erros da API retornando um mapa de erro
        return {
          'error': 'Erro de login: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Lida com erros de conexão ou outros e retorna um mapa com o erro
      print('Erro ao fazer login: $e');
      return {
        'error': 'Erro de conexão: $e',
      };
    }
  }

}
