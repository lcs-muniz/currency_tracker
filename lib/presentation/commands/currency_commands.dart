import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/patterns/command.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';
import 'package:currency_tracker/domain/facades/i_currency_use_case_facade.dart';
import 'package:currency_tracker/core/patterns/result.dart';

final class AddCurrencyCommand
    extends ParameterizedCommand<void, Failure, CurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  AddCurrencyCommand(this._currencyUseCaseFacade);

  @override
  Future<VoidResult> execute() async {
    await Future.delayed(const Duration(seconds: 2)); // simula delay

    if (parameter == null) {
      return Error(InvalidInputFailure('Dados de moeda nulos ao adicionar.'));
    }
    return await _currencyUseCaseFacade.addCurrency(parameter!);
  }
}

final class RemoveCurrencyCommand
    extends ParameterizedCommand<void, Failure, CodeCurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  RemoveCurrencyCommand(this._currencyUseCaseFacade);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null || parameter!.code.isEmpty) {
      return Error(InvalidInputFailure('Código de moeda nulo.'));
    }
    return await _currencyUseCaseFacade.removeCurrency(parameter!);
  }
}

final class UpdateCurrencyCommand
    extends ParameterizedCommand<void, Failure, CurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  UpdateCurrencyCommand(this._currencyUseCaseFacade);

  @override
  Future<VoidResult> execute() async {
    await Future.delayed(const Duration(seconds: 2)); // simula delay
    if (parameter == null) {
      return Error(InvalidInputFailure('Dados de moeda nulos ao atualizar.'));
    }
    return await _currencyUseCaseFacade.updateCurrency(parameter!);
  }
}

final class GetCurrencyCommand
    extends ParameterizedCommand<Currency, Failure, CodeCurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  GetCurrencyCommand(this._currencyUseCaseFacade);

  @override
  Future<CurrencyResult> execute() async {
    if (parameter == null || parameter!.code.isEmpty) {
      return Error(InvalidInputFailure('Código de moeda nulo ao buscar.'));
    }
    return await _currencyUseCaseFacade.getCurrency(parameter!);
  }
}

final class GetAllCurrenciesCommand
    extends ParameterizedCommand<List<Currency>, Failure, CodeCurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  GetAllCurrenciesCommand(this._currencyUseCaseFacade);

  @override
  Future<CurrencyListResult> execute() async {
    return await _currencyUseCaseFacade.getAllCurrencies();
  }
}

final class GetFavoriteCurrenciesCommand
    extends ParameterizedCommand<List<Currency>, Failure, NoParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  GetFavoriteCurrenciesCommand(this._currencyUseCaseFacade);

  @override
  Future<CurrencyListResult> execute() async {
    return await _currencyUseCaseFacade.getFavoriteCurrencies();
  }
}

final class GetHistoricalQuotesCommand extends ParameterizedCommand<
    List<HistoricalQuote>, Failure, CodeCurrencyParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  GetHistoricalQuotesCommand(this._currencyUseCaseFacade);

  @override
  Future<HistoricalQuotesResult> execute() async {
    if (parameter == null || parameter!.code.isEmpty) {
      return Error(
          InvalidInputFailure('Código de moeda nulo ao buscar histórico.'));
    }
    return await _currencyUseCaseFacade.getHistoricalQuotes(parameter!);
  }
}

final class LoadCurrenciesCommand
    extends ParameterizedCommand<List<Currency>, Failure, NoParams> {
  final ICurrencyUseCaseFacade _currencyUseCaseFacade;

  LoadCurrenciesCommand(this._currencyUseCaseFacade);

  @override
  Future<CurrencyListResult> execute() async {
    final result = await _currencyUseCaseFacade.getAllCurrencies();

    return result.fold(
      onSuccess: (currencies) {
        if (currencies.isEmpty) {
          print(
              'INFO: API e cache local falharam ou estão vazios. Usando dados mock de fallback.');
          return _currencyUseCaseFacade.getMockCurrencies();
        }
        return Success(currencies);
      },
      onFailure: (error) {
        print(
            'ERRO: Falha geral ao carregar moedas. Usando dados mock de fallback. Erro: $error');
        return _currencyUseCaseFacade.getMockCurrencies();
      },
    );
  }
}
