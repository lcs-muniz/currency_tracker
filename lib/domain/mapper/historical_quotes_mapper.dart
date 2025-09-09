import 'package:currency_tracker/domain/entities/historical_quote.dart';

class HistoricalQuoteMapper {
  static HistoricalQuote fromMap(Map<String, dynamic> map) {
    return HistoricalQuote(
      currencyCode: map['currency_code'] as String,
      quoteValue: (map['quote_value'] as num).toDouble(),
      timestamp: map['timestamp'] as int,
    );
  }

  static Map<String, dynamic> toMap(HistoricalQuote entity) {
    return {
      'currency_code': entity.currencyCode,
      'quote_value': entity.quoteValue,
      'timestamp': entity.timestamp,
    };
  }

  static List<HistoricalQuote> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map(fromMap).toList();
  }

  static List<Map<String, dynamic>> toMapList(List<HistoricalQuote> entities) {
    return entities.map(toMap).toList();
  }
}
