import 'package:currency_tracker/domain/entities/historical_quote.dart';

class HistoricalQuoteFactory {
  /// Mock de uma única cotação histórica
  static HistoricalQuote single({
    String currencyCode = 'USD',
    double quoteValue = 5.25,
    int? timestamp,
  }) {
    return HistoricalQuote(
      currencyCode: currencyCode,
      quoteValue: quoteValue,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Mock de uma lista de cotações históricas
  static List<HistoricalQuote> list({
    String currencyCode = 'USD',
    int count = 10,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      count,
      (index) => single(
        currencyCode: currencyCode,
        quoteValue: 5.0 + (index * 0.1),
        timestamp: now - (index * 86400000), // menos 1 dia por item
      ),
    );
  }
}
