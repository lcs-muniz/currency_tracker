import 'package:currency_tracker/domain/entities/currency.dart';

class CurrencyMapper {
  
  /// Converte um Map (API ou DB) para entidade do domínio
  static Currency fromMap(Map<String, dynamic> map) {
    return Currency(
      name: map['name'] as String,
      code: map['code'] as String,
      isFavorite: map['is_favorite'] == 1, // banco retorna int (0 ou 1)
      latestQuote: (map['latest_quote'] as num).toDouble(),
    );
  }

  /// Converte entidade do domínio para Map (para salvar no DB ou enviar para API)
  static Map<String, dynamic> toMap(Currency entity) {
    return {
      'name': entity.name,
      'code': entity.code,
      'is_favorite': entity.isFavorite ? 1 : 0,
      'latest_quote': entity.latestQuote,
    };
  }

  /// Converte lista de Maps em lista de entidades
  static List<Currency> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map(fromMap).toList();
  }

  /// Converte lista de entidades para lista de Maps
  static List<Map<String, dynamic>> toMapList(List<Currency> entities) {
    return entities.map(toMap).toList();
  }
}
