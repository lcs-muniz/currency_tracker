import 'package:signals_flutter/signals_flutter.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';

class CurrencyState {
  final isInitialized = signal<bool>(false);
  final currencies = signal<List<Currency>>([]);
  final quotes = signal<List<HistoricalQuote>>([]);
  final errorMessage = signal<String?>(null);
  final snackMessage = signal<String?>(null);

  // Métodos auxiliares
  void clearError() => errorMessage.value = null;
  void setError(String msg) => errorMessage.value = msg;
}
