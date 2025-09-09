import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';


import '../../test_utils/factories/factories.dart';
import '../usecases/i_usecases.dart';
import 'i_currency_use_case_facade.dart';

class CurrencyUseCaseFacadeImpl implements ICurrencyUseCaseFacade {
  final IGetLatestQuoteUseCase _getLatestQuoteUseCase;
  final IAddCurrencyUseCase _addCurrencyUseCase;
  final IRemoveCurrencyUseCase _removeCurrencyUseCase;
  final IUpdateCurrencyUseCase _updateCurrencyUseCase;
  final IGetCurrencyUseCase _getCurrencyUseCase;
  final IGetAllCurrenciesUseCase _getAllCurrenciesUseCase;
  final IGetFavoriteCurrenciesUseCase _getFavoriteCurrenciesUseCase;
  final IGetHistoricalQuotesUseCase _getHistoricalQuotesUseCase;

  CurrencyUseCaseFacadeImpl({
    required IGetLatestQuoteUseCase getLatestQuoteUseCase,
    required IAddCurrencyUseCase addCurrencyUseCase,
    required IRemoveCurrencyUseCase removeCurrencyUseCase,
    required IUpdateCurrencyUseCase updateCurrencyUseCase,
    required IGetCurrencyUseCase getCurrencyUseCase,
    required IGetAllCurrenciesUseCase getAllCurrenciesUseCase,
    required IGetFavoriteCurrenciesUseCase getFavoriteCurrenciesUseCase,
    required IGetHistoricalQuotesUseCase getHistoricalQuotesUseCase,
  })  : _getLatestQuoteUseCase = getLatestQuoteUseCase,
        _addCurrencyUseCase = addCurrencyUseCase,
        _removeCurrencyUseCase = removeCurrencyUseCase,
        _updateCurrencyUseCase = updateCurrencyUseCase,
        _getCurrencyUseCase = getCurrencyUseCase,
        _getAllCurrenciesUseCase = getAllCurrenciesUseCase,
        _getFavoriteCurrenciesUseCase = getFavoriteCurrenciesUseCase,
        _getHistoricalQuotesUseCase = getHistoricalQuotesUseCase;

  @override
  Future<CurrencyResult> getLatestQuote() {
    return _getLatestQuoteUseCase(());
  }

  @override
  Future<VoidResult> addCurrency(CurrencyParams params) {
    return _addCurrencyUseCase(params);
  }

  @override
  Future<VoidResult> removeCurrency(CodeCurrencyParams params) {
    return _removeCurrencyUseCase(params);
  }

  @override
  Future<VoidResult> updateCurrency(CurrencyParams params) {
    return _updateCurrencyUseCase(params);
  }

  @override
  Future<CurrencyResult> getCurrency(CodeCurrencyParams params) {
    return _getCurrencyUseCase(params);
  }

  @override
  Future<CurrencyListResult> getAllCurrencies() {
    return _getAllCurrenciesUseCase(());
  }

  @override
  Future<CurrencyListResult> getFavoriteCurrencies() {
    return _getFavoriteCurrenciesUseCase(());
  }

  @override
  Future<HistoricalQuotesResult> getHistoricalQuotes(
      CodeCurrencyParams params) {
    return _getHistoricalQuotesUseCase(params);
  }

  @override
  CurrencyListResult getMockCurrencies() {
    return Success(CurrencyFactory.list());
  }

  @override
  CurrencyResult getMockCurrency() {
    return Success(CurrencyFactory.single());
  }

  @override
  HistoricalQuotesResult getMockHistoricalQuotes() {
    return Success(HistoricalQuoteFactory.list());
  }
}
