import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class GetLatestQuoteUsecase implements IGetLatestQuoteUseCase {
  final ICurrencyRepository _repository;

  GetLatestQuoteUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<CurrencyResult> call([NoParams params = const ()]) async {
    return _repository.getLatestQuote();
  }
}
