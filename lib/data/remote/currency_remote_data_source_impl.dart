import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/messages/app_messages.dart';
import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import '../../core/api/api_config.dart';
import '../../domain/mapper/currency_mapper.dart';
import 'i_currency_remote_service.dart';
import 'api_http_client_service.dart';

class CurrencyRemoteDataSourceImpl implements ICurrencyRemoteService {
  CurrencyRemoteDataSourceImpl();

  @override
  Future<CurrencyResult> getLatestQuote() async {
    try {
      const url = ApiConfig.baseUrl;
      final response = await ApiHttpClientService.get(url);

      final currency = CurrencyMapper.fromMap(response);
      return Success(currency);
    } on ApiException catch (e) {
      return Error(ApiException(e.msg));
    } catch (e) {
      return Error(DefaultFailure(AppMessages.error.defaultError));
    }
  }
}
