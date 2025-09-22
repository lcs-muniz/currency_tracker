import 'dart:async';
import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/patterns/command.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/presentation/commands/currency_commands.dart';
import 'currency_state.dart';

class CurrencyEffectsCommands {
  final CurrencyState state;
  final LoadCurrenciesCommand loadCmd;
  final AddCurrencyCommand addCmd;
  final UpdateCurrencyCommand updateCmd;
  final RemoveCurrencyCommand removeCmd;

  Currency? _currentCurrency;
  int _lastAccessedIndex = -1;

  Currency? _deletedCurrency;
  Timer? _deleteTimer;

  CurrencyEffectsCommands({
    required this.state,
    required this.loadCmd,
    required this.addCmd,
    required this.updateCmd,
    required this.removeCmd,
  }) {
    _observeLoad();
    _observeAdd();
    _observeUpdate();
    _observeRemove();
  }

  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;
      final result = command.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (data) {
          state.clearError();
          onSuccess(data);
        },
        onFailure: (err) {
          state.setError(err.msg);
          if (onFailure != null) onFailure(err);
        },
      );
    });
  }

  void _observeLoad() {
    _observeCommand<List<Currency>>(
      loadCmd,
      onSuccess: (currencies) {
        state.currencies.value = currencies;
      },
      onFailure: (err) {
        if (state.currencies.value.isEmpty) {
          state.currencies.value = [];
        }
      },
    );
  }

  void _observeAdd() {
    _observeCommand<void>(
      addCmd,
      onSuccess: (_) {
        if (!state.currencies.value
            .any((c) => c.code == _currentCurrency!.code)) {
          state.currencies.value = [
            ...state.currencies.value,
            _currentCurrency!
          ];
        }
        _currentCurrency = null;
        state.snackMessage.value = 'Moeda adicionada com sucesso!';
      },
      onFailure: (_) {
        state.snackMessage.value = 'Erro ao adicionar moeda!';
        _currentCurrency = null;
      },
    );
  }

  void _observeUpdate() {
    _observeCommand<void>(
      updateCmd,
      onSuccess: (_) {
        final updated = List<Currency>.from(state.currencies.value);
        updated[_lastAccessedIndex] = _currentCurrency!;
        state.currencies.value = updated;
        _lastAccessedIndex = -1;
        state.snackMessage.value = 'Moeda atualizada com sucesso!';
        _currentCurrency = null;
      },
      onFailure: (_) {
        state.snackMessage.value = 'Erro ao atualizar moeda!';
        _currentCurrency = null;
        _lastAccessedIndex = -1;
      },
    );
  }

  void _observeRemove() {
    _observeCommand<void>(
      removeCmd,
      onSuccess: (_) {
        _deletedCurrency = null;
      },
      onFailure: (_) {
        if (_deletedCurrency != null) {
          state.currencies.value = [
            ...state.currencies.value,
            _deletedCurrency!
          ];
        }
        state.snackMessage.value = 'Erro ao remover moeda!';
      },
    );
  }

  Future<void> _confirmRemove() async {
    if (_deletedCurrency != null) {
      await removeCmd.executeWith((code: _deletedCurrency!.code));
    }
  }

  void removeCurrencyOptimistic(Currency currency) {
    _deleteTimer?.cancel();
    _deletedCurrency = currency;

    state.currencies.value =
        state.currencies.value.where((c) => c.code != currency.code).toList();

    state.snackMessage.value = '${currency.name} removida.';

    _deleteTimer = Timer(const Duration(seconds: 3), _confirmRemove);
  }

  void undoRemove() {
    _deleteTimer?.cancel();

    if (_deletedCurrency != null) {
      state.currencies.value = [...state.currencies.value, _deletedCurrency!];
      _deletedCurrency = null;
    }
  }

  Future<void> loadCurrencies() async {
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

  void dispose() {
    _deleteTimer?.cancel();
    loadCmd.reset();
    addCmd.reset();
    updateCmd.reset();
    removeCmd.reset();
  }

  AddCurrencyCommand get addCurrencyCommand => addCmd;
  UpdateCurrencyCommand get updateCurrencyCommand => updateCmd;
  LoadCurrenciesCommand get loadCurrenciesCommand => loadCmd;
  RemoveCurrencyCommand get removeCurrencyCommand => removeCmd;
}
