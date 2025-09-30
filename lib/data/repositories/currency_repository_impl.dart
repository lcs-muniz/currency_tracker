import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/database/i_database_service.dart';
import 'package:currency_tracker/data/remote/i_currency_remote_service.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';

class CurrencyRepositoryImpl implements ICurrencyRepository {
  final ICurrencyRemoteService _remoteDataSource;
  final IDatabaseService _localDatabase;

  final List<String> _majorCurrencies = [
    'BRL',
    'USD',
    'EUR',
    'JPY',
    'CNY',
  ];

  CurrencyRepositoryImpl({
    required ICurrencyRemoteService remoteDataSource,
    required IDatabaseService databaseService,
  })  : _remoteDataSource = remoteDataSource,
        _localDatabase = databaseService;

  @override
  Future<CurrencyListResult> getLatestQuotes(String baseCurrency) async {
    return await _remoteDataSource.getRatesFor(baseCurrency);
  }

  @override
  Future<VoidResult> addCurrency(Currency currency) async {
    return await _localDatabase.insertCurrency(currency);
  }

  @override
  Future<VoidResult> removeCurrency(String code) async {
    return await _localDatabase.deleteCurrency(code);
  }

  @override
  Future<VoidResult> updateCurrency(Currency currency) async {
    return await _localDatabase.updateCurrency(currency);
  }

  @override
  Future<CurrencyResult> getCurrency(String code) async {
    return await _localDatabase.getCurrency(code);
  }

  // SINCRONIZAÇÃO E FILTRAGEM
  @override
  Future<CurrencyListResult> getAllCurrencies() async {
    await _syncWithRemoteData();

    return _getFilteredLocalCurrencies();
  }

  Future<void> _syncWithRemoteData() async {
    final remoteResult = await _remoteDataSource.getInitialRates();

    if (remoteResult.isSuccess) {
      final remoteCurrencies = remoteResult.successValueOrNull!;

      final filteredRemoteCurrencies = remoteCurrencies
          .where((c) => _majorCurrencies.contains(c.code))
          .toList();

      await _saveOrUpdateCurrencies(filteredRemoteCurrencies);
    }
  }

  Future<void> _saveOrUpdateCurrencies(List<Currency> currencies) async {
    for (var currency in currencies) {
      final localResult = await _localDatabase.getCurrency(currency.code);

      await _saveHistoricalQuote(currency);

      if (localResult.isSuccess) {
        final existingCurrency = localResult.successValueOrNull!;
        await _localDatabase.updateCurrency(
          currency.copyWith(isFavorite: existingCurrency.isFavorite),
        );
      } else {
        await _localDatabase.insertCurrency(currency);
      }
    }
  }

  Future<void> _saveHistoricalQuote(Currency currency) async {
    final historicalQuote = HistoricalQuote(
      currencyCode: currency.code,
      quoteValue: currency.latestQuote,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _localDatabase.insertHistoricalQuote(historicalQuote);
  }

  Future<CurrencyListResult> _getFilteredLocalCurrencies() async {
    final localCurrencies = await _localDatabase.getCurrencies();
    if (localCurrencies.isSuccess) {
      final filteredLocalCurrencies = localCurrencies.successValueOrNull!
          .where((c) => _majorCurrencies.contains(c.code))
          .toList();
      return Success(filteredLocalCurrencies);
    }
    return localCurrencies;
  }

  @override
  Future<CurrencyListResult> getFavoriteCurrencies() async {
    return await _localDatabase.getFavoriteCurrencies();
  }

  @override
  Future<HistoricalQuotesResult> getHistoricalQuotes(
      String currencyCode) async {
    return await _localDatabase.getHistoricalQuotes(currencyCode);
  }
}
