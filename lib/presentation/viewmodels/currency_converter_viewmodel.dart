import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CurrencyConverterController {
  final _fromCurrency = signal<Currency?>(null);
  final _toCurrency = signal<Currency?>(null);
  final _amountToConvert = signal<double>(1.0);
  //final result = signal<double>(0.0);

  // Getters para acessar signals (readonly)
  ReadonlySignal<Currency?> get fromCurrency => _fromCurrency.readonly();
  ReadonlySignal<Currency?> get toCurrency => _toCurrency.readonly();
  ReadonlySignal<double> get amount => _amountToConvert.readonly();
  
  /// setters 
  void setFromCurrency(Currency currency) => _fromCurrency.value = currency;
  void setToCurrency(Currency currency) => _toCurrency.value = currency;
  void setAmount(double amount) => _amountToConvert.value = amount;


  // computeted to convert amount
  late final amountConverted = computed(() {
    
    if (_fromCurrency.value == null || _toCurrency.value == null) {
      return 0.0;
    }

    return _amountToConvert.value *
      (_toCurrency.value!.latestQuote / _fromCurrency.value!.latestQuote);
  });
}
