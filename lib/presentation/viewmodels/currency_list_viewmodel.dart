import 'package:currency_tracker/domain/facades/i_currency_use_case_facade.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';
import 'package:currency_tracker/presentation/viewmodels/currency_effect_commands.dart';
import 'package:currency_tracker/test_utils/factories/historical_quote_factory.dart';
import 'package:currency_tracker/presentation/commands/currency_commands.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'currency_state.dart';

class CurrencyListController {
  final CurrencyState _state;
  late final CurrencyEffectsCommands _effects;

  CurrencyListController(ICurrencyUseCaseFacade facade)
      : _state = CurrencyState() {
    _effects = CurrencyEffectsCommands(
      state: _state,
      loadCmd: LoadCurrenciesCommand(facade),
      addCmd: AddCurrencyCommand(facade),
      updateCmd: UpdateCurrencyCommand(facade),
      removeCmd: RemoveCurrencyCommand(facade),
    );
  }

  ReadonlySignal<List<Currency>> get currencies => _state.currencies.readonly();
  ReadonlySignal<List<HistoricalQuote>> get quotes => _state.quotes.readonly();
  ReadonlySignal<String?> get errorMessage => _state.errorMessage.readonly();
  ReadonlySignal<String?> get snackMessage => _state.snackMessage.readonly();

  AddCurrencyCommand get addCurrencyCommand => _effects.addCurrencyCommand;
  UpdateCurrencyCommand get updateCurrencyCommand =>
      _effects.updateCurrencyCommand;
  LoadCurrenciesCommand get loadCurrenciesCommand =>
      _effects.loadCurrenciesCommand;
  RemoveCurrencyCommand get removeCurrencyCommand =>
      _effects.removeCurrencyCommand;

  Computed<bool> get isExecuting => computed(() =>
      _effects.loadCmd.isExecuting.value ||
      _effects.addCmd.isExecuting.value ||
      _effects.updateCmd.isExecuting.value ||
      _effects.removeCmd.isExecuting.value);

  Future<void> loadCurrencies() => _effects.loadCurrencies();
  Future<void> addCurrency(Currency c) => _effects.addCurrency(c);
  Future<void> updateCurrency(Currency c) => _effects.updateCurrency(c);

  Future<void> removeCurrency(Currency c) async =>
      _effects.removeCurrencyOptimistic(c);

  Future<void> undoRemove() async {
    _effects.undoRemove();
  }

  Future<void> toggleFavorite(String code) async {
    final updated = _state.currencies.value.map((c) {
      return c.code == code ? c.copyWith(isFavorite: !c.isFavorite) : c;
    }).toList();
    _state.currencies.value = updated;

    final currencyToUpdate = updated.firstWhere((c) => c.code == code);
    await updateCurrency(currencyToUpdate);
  }

  void loadQuotesForCurrency(String code) {
    final fakeQuotes =
        HistoricalQuoteFactory.list(currencyCode: code, count: 10);
    _state.quotes.value = fakeQuotes;
  }

  Currency? getCurrencyByCode(String code) {
    try {
      return _state.currencies.value.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }

  String? consumeSnackMessage() {
    final msg = _state.snackMessage.value;
    _state.snackMessage.value = null;
    return msg;
  }

  void clearSearch() {
    _state.clearError();
    _effects.loadCmd.clear();
    _effects.addCmd.clear();
    _effects.updateCmd.clear();
  }

  void dispose() {
    _effects.dispose();
  }
}
