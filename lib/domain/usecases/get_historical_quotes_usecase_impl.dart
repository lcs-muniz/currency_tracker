import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class GetHistoricalQuotesUsecase implements IGetHistoricalQuotesUseCase {
  final ICurrencyRepository _repository;

  GetHistoricalQuotesUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<HistoricalQuotesResult> call(CodeCurrencyParams params) async {
    return _repository.getHistoricalQuotes(params.code);
  }
}
