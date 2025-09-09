
import 'package:currency_tracker/core/typesdef/types_defs.dart';

abstract interface class IUseCase<T, Params extends Object?> {
  Future<T> call(Params params);
}
abstract interface class IGetLatestQuoteUseCase
    implements IUseCase<CurrencyResult,NoParams> {}
abstract interface class IAddCurrencyUseCase
    implements IUseCase<VoidResult,CurrencyParams> {}
abstract interface class IRemoveCurrencyUseCase
    implements IUseCase<VoidResult,CodeCurrencyParams> {}
abstract interface class IUpdateCurrencyUseCase 
    implements IUseCase<VoidResult,CurrencyParams> {}
abstract interface class IGetAllCurrenciesUseCase
    implements IUseCase<CurrencyListResult,NoParams> {}
abstract interface class IGetFavoriteCurrenciesUseCase
    implements IUseCase<CurrencyListResult,NoParams> {}
abstract interface class IGetHistoricalQuotesUseCase
    implements IUseCase<HistoricalQuotesResult,CodeCurrencyParams> {}    
abstract interface class IGetCurrencyUseCase
    implements IUseCase<CurrencyResult,CodeCurrencyParams> {}
