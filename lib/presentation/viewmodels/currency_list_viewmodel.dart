import 'package:currency_tracker/domain/entities/historical_quote.dart';
import 'package:currency_tracker/presentation/commands/currency_commands.dart';
import 'package:currency_tracker/test_utils/factories/historical_quote_factory.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:currency_tracker/domain/facades/i_currency_use_case_facade.dart';

import '../../domain/entities/currency.dart';

class CurrencyListController {
  // Dependências injetadas
  late final ICurrencyUseCaseFacade _currencyFacade;

  // Signals de estado geral da ViewController
  final _isInitialized = signal<bool>(false);

  // Estados da Controller usando Signals
  final _currencies = signal<List<Currency>>([]);
  // final _currentCurrency = signal<Currency?>(null);
  final _quotes = signal<List<HistoricalQuote>>([]);
  final _errorMessage = signal<String?>(null);
  final snackMessage = signal<String?>(null);

  // Getters para acessar signals (readonly)
  ReadonlySignal<bool> get isInitialized => _isInitialized.readonly();
  ReadonlySignal<List<Currency>> get currencies => _currencies.readonly();
  ReadonlySignal<List<HistoricalQuote>> get quotes => _quotes.readonly();
  ReadonlySignal<String?> get errorMessage => _errorMessage.readonly();

  // Comandos observáveis
  late final LoadCurrenciesCommand _loadCurrenciesCommand;
  late final AddCurrencyCommand _addCurrencyCommand;
  late final UpdateCurrencyCommand _updateCurrencyCommand;
  
  // Getters para comandos
  AddCurrencyCommand get addCurrencyCommand => _addCurrencyCommand;
  UpdateCurrencyCommand get updateCurrencyCommand => _updateCurrencyCommand;

  // atribututos de apoio
  Currency? _currentCurrency;
  int _lastAcessedIndex = -1;

  late final isExecuting = computed(() =>
      _loadCurrenciesCommand.isExecuting.value ||
      _addCurrencyCommand.isExecuting.value ||
      _updateCurrencyCommand.isExecuting.value);

  CurrencyListController({
    required ICurrencyUseCaseFacade currencyFacade,
  }) : _currencyFacade = currencyFacade {
    _initializeCommands();
  }

  // Inicializar comandos
  void _initializeCommands() {
    _loadCurrenciesCommand = LoadCurrenciesCommand(_currencyFacade);
    _addCurrencyCommand = AddCurrencyCommand(_currencyFacade);
    _updateCurrencyCommand = UpdateCurrencyCommand(_currencyFacade);

    // _addCurrencyCommand = AddCurrencyCommand(_currencyFacade);

    // Observar o comando de carregar moedas
    effect(() {
      if (_loadCurrenciesCommand.isExecuting.value) return;

      final result = _loadCurrenciesCommand.result.value;

      if (result == null) return;

      result.fold(
        onSuccess: (currencies) {
          _currencies.value = currencies;
          _clearError();
        },
        onFailure: (error) {
          _setError(error.msg);

          if (_currencies.value.isEmpty) {
            _currencies.value = [];
          }
        },
      );
    });

    // observa efeito observa o comando de adicionar moeda
    effect(() {
      if (_addCurrencyCommand.isExecuting.value) return;
      final result = _addCurrencyCommand.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (_) {
          _clearError();
          _currencies.value = [..._currencies.value, _currentCurrency!];
          // _currencies.value = [..._currencies.value, _currentCurrency.value!];
          // _currentCurrency.value = null;
          _currentCurrency = null;
          snackMessage.value = 'Moeda adicionada com sucesso!';
        },
        onFailure: (error) {
          snackMessage.value = 'Erro ao adicionar moeda!';
          _setError(error.msg);
          // _currentCurrency.value = null;
          _currentCurrency = null;
        },
      );
    });

    // este efeito observa o comando de atualização de moeda
    effect(() {
      if (_updateCurrencyCommand.isExecuting.value) return;
      final result = _updateCurrencyCommand.result.value;

      if (result == null) return;

      result.fold(
        onSuccess: (_) {
          _clearError();
          final updatedList = List<Currency>.from(_currencies.value);
          updatedList[_lastAcessedIndex] = _currentCurrency!;
          _currencies.value = updatedList;
          _lastAcessedIndex = -1;
          snackMessage.value = 'Moeda atualizada com sucesso!';
          // _currentCurrency.value = null;
          _currentCurrency = null;
        },
        onFailure: (error) {
          _setError(error.msg);
          // _currentCurrency.value = null;
          snackMessage.value = 'Erro ao atualizar moeda!';
          _currentCurrency = null;
          _lastAcessedIndex = -1;
        },
      );
    });
  }

  Future<void> updateCurrency(Currency newCurrency) async {
    _clearError();
    _currentCurrency = newCurrency.copyWith();

    _lastAcessedIndex =
        _currencies.value.indexWhere((c) => c.code == newCurrency.code);

    await _updateCurrencyCommand.executeWith((currency: newCurrency));
  }

  Future<void> addCurrency(Currency newCurrency) async {
    _clearError();
    // _currentCurrency.value = newCurrency.copyWith();
    _currentCurrency = newCurrency.copyWith();
    await _addCurrencyCommand.executeWith((currency: newCurrency));
  }

  Future<void> loadCurrencies() async {
    _clearError();
    await _loadCurrenciesCommand.executeWith(());
  }

  Future<void> toggleFavorite(String code) async {
    // Clona a lista atual
    final updated = _currencies.value.map((currency) {
      if (currency.code == code) {
        // Cria uma nova instância com isFavorite invertido
        return Currency(
          name: currency.name,
          code: currency.code,
          isFavorite: !currency.isFavorite,
          latestQuote: currency.latestQuote,
        );
      }
      return currency;
    }).toList();

    // Atualiza o signal
    _currencies.value = updated;
  }

  void loadQuotesForCurrency(String Code) {
    // Aqui você depois vai buscar no SQLite
    final fakeQuotes =
        HistoricalQuoteFactory.list(currencyCode: Code, count: 10);

    _quotes.value = fakeQuotes; // atualiza o signal
  }

  void _clearError() {
    _errorMessage.value = null;
  }

  // Métodos privados para gerenciar erro
  void _setError(String message) {
    _errorMessage.value = message;
  }

  // Limpar busca
  void clearSearch() {
    _clearError();
    _initializeData();

    // Limpar comandos
    _loadCurrenciesCommand.clear();
    _addCurrencyCommand.clear();
    _updateCurrencyCommand.clear();
  }

  // Dispose resources
  void dispose() {
    _loadCurrenciesCommand.reset();
    _addCurrencyCommand.reset();
    _updateCurrencyCommand.reset();
  }

  // Inicializar com dados mock
  void _initializeData() {
    //searchLoadCurrencies();
    _isInitialized.value = true;
  }

  Currency? getCurrencyByCode(String code) {
    try {
      return _currencies.value.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }
}
