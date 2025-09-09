import 'package:currency_tracker/core/typesdef/types_defs.dart';


abstract class ICurrencyRemoteService {
  Future<CurrencyResult> getLatestQuote();
}