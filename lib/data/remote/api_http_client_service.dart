import 'dart:convert';
import 'dart:io';
import 'package:currency_tracker/core/failures/failure.dart';
import 'package:http/http.dart' as http;

class ApiHttpClientService {
  static const Duration _timeout = Duration(seconds: 30);

  // Método genérico para GET requests
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      print("📡 Fazendo requisição GET para a URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', ...?headers},
      ).timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on HttpException {
      throw ApiException('Erro na requisição HTTP');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  // Método genérico para POST requests
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Sem conexão com a internet');
    } on HttpException {
      throw ApiException('Erro na requisição HTTP');
    } catch (e) {
      throw ApiException('Erro inesperado: $e');
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      print("✅ RESPOSTA DA API RECEBIDA COM SUCESSO!");
      return json.decode(response.body);
    } else {
      print("❌ ERRO DA API: Status Code: ${response.statusCode}");
      print("❌ CORPO DA RESPOSTA: ${response.body}");
      switch (response.statusCode) {
        case 400:
          throw ApiException('Requisição inválida');
        case 401:
          throw ApiException('Não autorizado');
        case 403:
          throw ApiException('Acesso negado');
        case 404:
          throw ApiException('Recurso não encontrado');
        case 500:
          throw ApiException('Erro interno do servidor');
        default:
          throw ApiException('Erro na API: ${response.statusCode}');
      }
    }
  }

  static Map<String, dynamic> _mockResponse() {
    const jsonString = '''
      {
        "name": "Futsal City",
        "main": {
          "temp": 24.5,
          "pressure": 1013,
          "humidity": 60
        },
        "weather": [
          {
            "main": "Clear",
            "description": "céu limpo"
          }
        ],
        "wind": {
          "speed": 3.5
        },
        "list": [
          {
            "dt_txt": "2025-08-16 12:00:00",
            "main": {
              "temp_min": 17.0,
              "temp_max": 25.0,
              "pressure": 1012,
              "humidity": 60
            },
            "weather": [
              {
                "main": "Clear",
                "description": "céu limpo"
              }
            ]
          },
          {
            "dt_txt": "2025-08-17 12:00:00",
            "main": {
              "temp_min": 15.0,
              "temp_max": 21.0,
              "pressure": 1015,
              "humidity": 70
            },
            "weather": [
              {
                "main": "Clouds",
                "description": "parcialmente nublado"
              }
            ]
          },
          {
            "dt_txt": "2025-08-18 12:00:00",
            "main": {
              "temp_min": 13.0,
              "temp_max": 18.0,
              "pressure": 1008,
              "humidity": 80
            },
            "weather": [
              {
                "main": "Rain",
                "description": "chuva leve"
              }
            ]
          },
          {
            "dt_txt": "2025-08-19 12:00:00",
            "main": {
              "temp_min": 16.0,
              "temp_max": 24.0,
              "pressure": 1010,
              "humidity": 68
            },
            "weather": [
              {
                "main": "Clouds",
                "description": "nuvens dispersas"
              }
            ]
          },
          {
            "dt_txt": "2025-08-20 12:00:00",
            "main": {
              "temp_min": 20.0,
              "temp_max": 28.0,
              "pressure": 1011,
              "humidity": 55
            },
            "weather": [
              {
                "main": "Clear",
                "description": "ensolarado"
              }
            ]
          }
        ]
      }
      ''';
    return json.decode(jsonString);
  }
}
