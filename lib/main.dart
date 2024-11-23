import 'package:flutter/material.dart';
import 'register_page.dart';
import 'main_page.dart';
import 'passo_passo.dart';
import 'help_page.dart';
import 'pontuacao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APP Lixeiras',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/Register',
      routes: {
        '/Register': (context) => RegisterPage(),
        '/Main': (context) => MainPage(),
        '/Passo': (context) => Passo(),
        '/Help': (context) => HelpPage(),
        '/Pontuacao': (context) => Pontuacao(),
      },
    );
  }
}
