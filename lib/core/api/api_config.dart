import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String apiKey = dotenv.env['API_KEY'] ?? 'CHAVE_NAO_ENCONTRADA';

  static String getBaseUrl(String baseCurrency) {
    print("🔑 Chave de API carregada: $apiKey");
    print("🌐 Construindo URL para base: $baseCurrency");
    return 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$baseCurrency';
  }
}
