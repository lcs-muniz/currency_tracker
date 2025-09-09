import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/repositories/i_currency_repository.dart';
import 'package:currency_tracker/domain/usecases/i_usecases.dart';

class GetAllCurrenciesUsecase implements IGetAllCurrenciesUseCase {
  final ICurrencyRepository _repository;

  GetAllCurrenciesUsecase({required ICurrencyRepository repository})
    : _repository = repository;

  @override
  Future<CurrencyListResult> call([NoParams params = const ()]) async {
    return _repository.getAllCurrencies();
  }
}
