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

  Currency? _currentCurrency;
  int _lastAccessedIndex = -1;

  CurrencyEffectsCommands({
    required this.state,
    required this.loadCmd,
    required this.addCmd,
    required this.updateCmd,
  }) {
    // Observadores que reagem automaticamente ao término dos comandos
    _observeLoad();
    _observeAdd();
    _observeUpdate();
  }

  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) Ignora até existir um resultado
      final result = command.result.value;
      if (result == null) return;

      // 3) Sucesso ou falha
      result.fold(
        onSuccess: (data) {
          state.clearError(); // sempre limpa erros em sucesso
          onSuccess(data); // ação específica para esse comando
        },
        onFailure: (err) {
          state.setError(err.msg); // registra o erro no estado
          if (onFailure != null) onFailure(err);
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  // Carregar moedas
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

  // Adicionar moeda
  void _observeAdd() {
    _observeCommand<void>(
      addCmd,
      onSuccess: (_) {
        state.currencies.value = [...state.currencies.value, _currentCurrency!];
        _currentCurrency = null;
        state.snackMessage.value = 'Moeda adicionada com sucesso!';
      },
      onFailure: (_) {
        state.snackMessage.value = 'Erro ao adicionar moeda!';
        _currentCurrency = null;
      },
    );
  }

  // Atualizar moeda
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

  // ========================================================
  //   MÉTODOS PÚBLICOS (CHAMADOS PELOS WIDGETS)
  // ========================================================

  Future<void> loadCurrencies() async {
    state.clearError();
    await loadCmd.executeWith(()); // dispara o comando
  }

  Future<void> addCurrency(Currency currency) async {
    state.clearError();
    _currentCurrency = currency.copyWith(); // guarda temporário
    await addCmd.executeWith((currency: currency));
  }

  Future<void> updateCurrency(Currency currency) async {
    state.clearError();
    _currentCurrency = currency.copyWith();
    _lastAccessedIndex =
        state.currencies.value.indexWhere((c) => c.code == currency.code);
    await updateCmd.executeWith((currency: currency));
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================

  AddCurrencyCommand get addCurrencyCommand => addCmd;
  UpdateCurrencyCommand get updateCurrencyCommand => updateCmd;
  LoadCurrenciesCommand get loadCurrenciesCommand => loadCmd;
}
