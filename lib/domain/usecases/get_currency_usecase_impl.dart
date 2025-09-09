import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class GetCurrencyUsecase implements IGetCurrencyUseCase {
  final ICurrencyRepository _repository;

  GetCurrencyUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<CurrencyResult> call(CodeCurrencyParams params) async {
    return _repository.getCurrency(params.code);
  }
}
