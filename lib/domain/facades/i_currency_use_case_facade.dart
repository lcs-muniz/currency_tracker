import 'package:currency_tracker/core/typesdef/types_defs.dart';

abstract interface class ICurrencyUseCaseFacade {
  Future<CurrencyResult> getLatestQuote();
  Future<VoidResult> addCurrency(CurrencyParams params);
  Future<VoidResult> removeCurrency(CodeCurrencyParams params);
  Future<VoidResult> updateCurrency(CurrencyParams params);
  Future<CurrencyResult> getCurrency(CodeCurrencyParams params);
  Future<CurrencyListResult> getAllCurrencies();
  Future<CurrencyListResult> getFavoriteCurrencies();
  Future<HistoricalQuotesResult> getHistoricalQuotes(CodeCurrencyParams params);
  
  // Dados mock para fallback
  CurrencyResult getMockCurrency();
  CurrencyListResult getMockCurrencies();
  HistoricalQuotesResult getMockHistoricalQuotes();
}
