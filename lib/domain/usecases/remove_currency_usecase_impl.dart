import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class RemoveCurrencyUsecase implements IRemoveCurrencyUseCase {
  final ICurrencyRepository _repository;

  RemoveCurrencyUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(CodeCurrencyParams params) async {
    return _repository.removeCurrency(params.code);
  }
}
