import 'package:currency_tracker/core/patterns/result.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:currency_tracker/core/failures/failure.dart';

// Interface base para comandos
abstract interface class ICommand<TSuccess, TFailure> {
  Future<Result<TSuccess, TFailure>> execute();
}

// Comando abstrato com estado reativo
abstract base class Command<TSuccess, TFailure>
    implements ICommand<TSuccess, TFailure> {
  final _running = signal(false);
  final _result = signal<Result<TSuccess, TFailure>?>(null);

  ReadonlySignal<bool> get isExecuting => _running.readonly();
  ReadonlySignal<Result<TSuccess, TFailure>?> get result => _result.readonly();

  late final hasResult = computed(() => _result.value != null);
  late final hasError = computed(() => _result.value?.isFailure ?? false);
  late final isSuccess = computed(() => _result.value?.isSuccess ?? false);

  Future<Result<TSuccess, TFailure>> call() async {
    if (_running.value) {
      return await future;
    }

    _running.value = true;
    _result.value = null;

    try {
      _result.value = await execute();
    } catch (e) {
      _result.value = Error(DefaultFailure('Erro inesperado no comando: $e'))
          as Result<TSuccess, TFailure>;
    }

    _running.value = false;

    if (_result.value == null) {
      throw Exception(
          'O método execute() retornou nulo, o que não é permitido.');
    }

    return _result.value!;
  }

  void clear() {
    _result.value = null;
  }

  void reset() {
    _running.value = false;
    clear();
  }

  Future<Result<TSuccess, TFailure>> get future async {
    while (_running.value) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (_result.value == null) {
      throw Exception('Future completed but the result is null.');
    }
    return _result.value!;
  }
}

// Comando parametrizado
abstract base class ParameterizedCommand<TSuccess, TFailure, P>
    extends Command<TSuccess, TFailure> {
  P? _parameter;

  set parameter(P? value) => _parameter = value;
  P? get parameter => _parameter;

  Future<Result<TSuccess, TFailure>> executeWith(P parameter) {
    _parameter = parameter;
    return call();
  }

  @override
  Future<Result<TSuccess, TFailure>> execute();
}

// Comando composto
final class CompositeCommand<TSuccess, TFailure>
    extends Command<List<TSuccess>, TFailure> {
  final List<Command<TSuccess, TFailure>> _commands;

  CompositeCommand(this._commands);

  @override
  Future<Result<List<TSuccess>, TFailure>> execute() async {
    final results = <TSuccess>[];
    for (final command in _commands) {
      final result = await command.call();
      if (result.isFailure) {
        return Error(result.failureValueOrNull as TFailure);
      }
      final value = result.successValueOrNull;
      if (value != null) {
        results.add(value);
      }
    }
    return Success(results);
  }
}
