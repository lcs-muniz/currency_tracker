
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/domain/entities/currency.dart';

abstract interface class ICurrencyRepository {
  // ultima cotaçao (dados remotos)
  Future<CurrencyResult> getLatestQuote();
  // adicionar moeda
  Future<VoidResult> addCurrency(Currency currency);
  // remover moeda
  Future<VoidResult> removeCurrency(String code);
  // atualizar moeda
  Future<VoidResult> updateCurrency(Currency currency);
  // buscar moeda pelo codigo
  Future<CurrencyResult> getCurrency(String code);
  // buscar todas as moedas
  Future<CurrencyListResult> getAllCurrencies();
  // busxcar moedas favoritas
  Future<CurrencyListResult> getFavoriteCurrencies();
  // buscar histórico de cotação pelo codigo
  Future<HistoricalQuotesResult> getHistoricalQuotes(String currencyCode);

}
