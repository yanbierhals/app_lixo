import 'dart:convert';
import 'package:http/http.dart' as http;

class LeiturasService {
  final String apiUrl = "https://api-lixo.onrender.com/api/leituras/12"; // URL corrigida

  // Função para listar as leituras sem autenticação
  Future<List<dynamic>> listarLeituras() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),  // Usando a URL corrigida
      );

      if (response.statusCode == 200) {
        List<dynamic> leituras = json.decode(response.body);
        return leituras;
      } else {
        throw Exception("Falha ao carregar leituras");
      }
    } catch (e) {
      throw Exception("Erro ao fazer a requisição: $e");
    }
  }
}