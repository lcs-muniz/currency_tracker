import 'package:signals_flutter/signals_flutter.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/presentation/commands/currency_commands.dart';
import 'currency_state.dart';

class CurrencyEffectsCommands {
  final CurrencyState state;
  final LoadCurrenciesCommand loadCmd;
  final AddCurrencyCommand addCmd;
  final UpdateCurrencyCommand updateCmd;

  Currency? _currentCurrency;
  int _lastAccessedIndex = -1;

  CurrencyEffectsCommands({
    required this.state,
    required this.loadCmd,
    required this.addCmd,
    required this.updateCmd,
  }) {
    _observeLoad();
    _observeAdd();
    _observeUpdate();
  }

  // --- Observers ---
  void _observeLoad() {
    effect(() {
      if (loadCmd.isExecuting.value) return;
      final result = loadCmd.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (currencies) {
          state.currencies.value = currencies;
          state.clearError();
        },
        onFailure: (err) {
          state.setError(err.msg);
          if (state.currencies.value.isEmpty) {
            state.currencies.value = [];
          }
        },
      );
    });
  }

  void _observeAdd() {
    effect(() {
      if (addCmd.isExecuting.value) return;
      final result = addCmd.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (_) {
          state.clearError();
          state.currencies.value = [
            ...state.currencies.value,
            _currentCurrency!
          ];
          _currentCurrency = null;
          state.snackMessage.value = 'Moeda adicionada com sucesso!';
        },
        onFailure: (err) {
          state.snackMessage.value = 'Erro ao adicionar moeda!';
          state.setError(err.msg);
          _currentCurrency = null;
        },
      );
    });
  }

  void _observeUpdate() {
    effect(() {
      if (updateCmd.isExecuting.value) return;
      final result = updateCmd.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (_) {
          state.clearError();
          final updated = List<Currency>.from(state.currencies.value);
          updated[_lastAccessedIndex] = _currentCurrency!;
          state.currencies.value = updated;
          _lastAccessedIndex = -1;
          state.snackMessage.value = 'Moeda atualizada com sucesso!';
          _currentCurrency = null;
        },
        onFailure: (err) {
          state.setError(err.msg);
          state.snackMessage.value = 'Erro ao atualizar moeda!';
          _currentCurrency = null;
          _lastAccessedIndex = -1;
        },
      );
    });
  }

  // --- Métodos públicos ---
  Future<void> loadCurrencies() async {
    print('entrou em loadCurrencies efect');
    state.clearError();
    await loadCmd.executeWith(());
  }

  Future<void> addCurrency(Currency currency) async {
    state.clearError();
    _currentCurrency = currency.copyWith();
    await addCmd.executeWith((currency: currency));
  }

  Future<void> updateCurrency(Currency currency) async {
    state.clearError();
    _currentCurrency = currency.copyWith();
    _lastAccessedIndex =
        state.currencies.value.indexWhere((c) => c.code == currency.code);
    await updateCmd.executeWith((currency: currency));
  }

  // --- Getters para widgets ---
  AddCurrencyCommand get addCurrencyCommand => addCmd;
  UpdateCurrencyCommand get updateCurrencyCommand => updateCmd;
  LoadCurrenciesCommand get loadCurrenciesCommand => loadCmd;
}
