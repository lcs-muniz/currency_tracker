import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/database/i_database_service.dart';
import 'package:currency_tracker/data/remote/i_currency_remote_service.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/entities/currency.dart';


class CurrencyRepositoryImpl implements ICurrencyRepository {
  final ICurrencyRemoteService _remoteDataSource;
  final IDatabaseService _localDatabase;

  CurrencyRepositoryImpl({
    required ICurrencyRemoteService remoteDataSource,
    required IDatabaseService databaseService,
  })  : _remoteDataSource = remoteDataSource,
        _localDatabase = databaseService;

  @override
  Future<CurrencyResult> getLatestQuote() async {
    return await _remoteDataSource.getLatestQuote();
  }

  @override
  Future<VoidResult> addCurrency(Currency currency) async {
    print('repository addCurrency: ${currency.code}');
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
  @override
  Future<CurrencyListResult> getAllCurrencies() async {
    return await _localDatabase.getCurrencies();
  }
  
  @override
  Future<CurrencyListResult> getFavoriteCurrencies() async {
    return await _localDatabase.getFavoriteCurrencies();
  }
  @override
  Future<HistoricalQuotesResult> getHistoricalQuotes(String currencyCode) async {
    return await _localDatabase.getHistoricalQuotes(currencyCode);
  }
  
  
}
