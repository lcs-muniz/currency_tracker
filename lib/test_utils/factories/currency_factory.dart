import 'package:currency_tracker/domain/entities/currency.dart';

class CurrencyFactory {
  /// Cria uma instância única de Currency
  static Currency single({
    String name = 'US Dollar',
    String code = 'USD',
    bool isFavorite = false,
    double latestQuote = 5.25,
  }) {
    return Currency(
      name: name,
      code: code,
      isFavorite: isFavorite,
      latestQuote: latestQuote,
    );
  }

  /// Cria uma lista de Currency
  static List<Currency> list([int count = 5]) {
    var currencies = List.generate(
      count,
      (index) => single(
        name: 'Currency $index',
        code: 'CUR$index',
        isFavorite: index.isEven,
        latestQuote: 4.5 + index,
      ),
    );
    currencies.add(single());
    currencies.add(single(code: 'EUR', name: 'Euro', latestQuote: 6.1));

    return currencies;
  }
}
