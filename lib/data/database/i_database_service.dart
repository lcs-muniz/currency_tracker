import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';

abstract interface class IDatabaseService {
  Future<VoidResult> insertCurrency(Currency currency);
  Future<VoidResult> updateCurrency(Currency currency);
  Future<VoidResult> deleteCurrency(String code);
  Future<CurrencyResult> getCurrency(String code);
  Future<CurrencyListResult> getCurrencies();
  Future<CurrencyListResult> getFavoriteCurrencies();
  Future<HistoricalQuotesResult> getHistoricalQuotes(String currencyCode);
  Future<void> insertHistoricalQuote(HistoricalQuote quote);
}
