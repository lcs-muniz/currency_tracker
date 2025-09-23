import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/messages/app_messages.dart';
import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import '../../core/api/api_config.dart';
import '../../domain/mapper/currency_mapper.dart';
import 'i_currency_remote_service.dart';
import 'api_http_client_service.dart';

class CurrencyRemoteDataSourceImpl implements ICurrencyRemoteService {
  @override
  Future<CurrencyListResult> getRatesFor(String baseCurrency) async {
    try {
      final url = ApiConfig.getBaseUrl(baseCurrency); // URL dinâmica
      final response = await ApiHttpClientService.get(url);
      final currencies = CurrencyMapper.fromApiMap(response);
      return Success(currencies);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultFailure(AppMessages.error.defaultError));
    }
  }

  @override
  Future<CurrencyListResult> getInitialRates() async {
    try {
      final url = ApiConfig.getBaseUrl('USD');
      final response = await ApiHttpClientService.get(url);
      final currencies = CurrencyMapper.fromApiMap(response);
      return Success(currencies);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultFailure(AppMessages.error.defaultError));
    }
  }
}