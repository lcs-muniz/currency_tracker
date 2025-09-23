import 'package:currency_tracker/core/typesdef/types_defs.dart';

abstract class ICurrencyRemoteService {
  Future<CurrencyListResult> getRatesFor(String baseCurrency);

  Future<CurrencyListResult> getInitialRates();
}