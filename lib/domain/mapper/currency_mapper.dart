import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/core/failures/failure.dart';

class CurrencyMapper {
  static Currency fromMap(Map<String, dynamic> map) {
    return Currency(
      name: map['name'] as String,
      code: map['code'] as String,
      isFavorite: map['is_favorite'] == 1,
      latestQuote: (map['latest_quote'] as num).toDouble(),
    );
  }

  static List<Currency> fromApiMap(Map<String, dynamic> apiMap) {
    if (apiMap['result'] != 'success') {
      final errorType = apiMap['error-type'] ?? 'erro desconhecido da API';
      throw ApiException('A API retornou um erro: $errorType');
    }

    final rates = apiMap['rates'] as Map<String, dynamic>;
    final List<Currency> currencies = [];

    rates.forEach((code, quote) {
      currencies.add(
        Currency(
          code: code,
          name: code,
          latestQuote: (quote as num).toDouble(),
          isFavorite: false,
        ),
      );
    });

    return currencies;
  }

  static Map<String, dynamic> toMap(Currency entity) {
    return {
      'name': entity.name,
      'code': entity.code,
      'is_favorite': entity.isFavorite ? 1 : 0,
      'latest_quote': entity.latestQuote,
    };
  }

  static List<Currency> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map(fromMap).toList();
  }

  static List<Map<String, dynamic>> toMapList(List<Currency> entities) {
    return entities.map(toMap).toList();
  }
}
