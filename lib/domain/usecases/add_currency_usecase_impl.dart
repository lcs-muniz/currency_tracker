import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class AddCurrencyUsecase implements IAddCurrencyUseCase {
  final ICurrencyRepository _repository;

  AddCurrencyUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(CurrencyParams params) async {
    return _repository.addCurrency(params.currency);
  }
}
