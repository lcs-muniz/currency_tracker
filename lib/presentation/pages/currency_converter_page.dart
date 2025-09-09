import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../core/di/injector.dart';
import '../viewmodels/currency_list_viewmodel.dart';
import '../viewmodels/currency_converter_viewmodel.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage>
    with SingleTickerProviderStateMixin {
  late final CurrencyListController listViewController;
  late final CurrencyConverterController currencyConverterController;
  late final TextEditingController _amountController;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(text: '1.0');
    _amountController.addListener(() {
      final value = double.tryParse(_amountController.text) ?? 0.0;
      currencyConverterController.setAmount(value);
      _animationController.forward(from: 0); // animação ao mudar
    });

    listViewController = injector.get<CurrencyListController>();
    if (listViewController.currencies.value.isEmpty) {
      listViewController.loadCurrencies();
    }

    currencyConverterController = injector.get<CurrencyConverterController>();

    // Animação para valor convertido
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // pega o tema atual (light/dark)

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Card de seleção de moedas
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.8),
                  theme.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Watch(
                  (context) => DropdownButtonFormField<String>(
                    value: currencyConverterController.fromCurrency.value?.code,
                    decoration: InputDecoration(
                      labelText: 'De',
                      labelStyle: TextStyle(
                        color: theme.colorScheme.secondary, // visível
                        fontWeight: FontWeight.w600,
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        var currency =
                            listViewController.getCurrencyByCode(newValue);
                        currencyConverterController.setFromCurrency(currency!);
                      }
                    },
                    items: listViewController.currencies.value
                        .map<DropdownMenuItem<String>>((currency) {
                      return DropdownMenuItem<String>(
                        value: currency.code,
                        child: Text(currency.code,
                            style:
                                TextStyle(color: theme.colorScheme.secondary)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Watch(
                  (context) => DropdownButtonFormField<String>(
                    value: currencyConverterController.toCurrency.value?.code,
                    decoration: InputDecoration(
                      labelText: 'Para',
                      labelStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      filled: true,
                      fillColor: theme.scaffoldBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        var currency =
                            listViewController.getCurrencyByCode(newValue);
                        currencyConverterController.setToCurrency(currency!);
                      }
                    },
                    items: listViewController.currencies.value
                        .map<DropdownMenuItem<String>>((currency) {
                      return DropdownMenuItem<String>(
                        value: currency.code,
                        child: Text(currency.code,
                            style:
                                TextStyle(color: theme.colorScheme.secondary)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // TextField de valor
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Valor',
              labelStyle: TextStyle(color: theme.colorScheme.secondary),
              prefixIcon:
                  Icon(Icons.attach_money, color: theme.colorScheme.secondary),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(fontSize: 18, color: theme.colorScheme.secondary),
          ),

          const SizedBox(height: 32),

          // Resultado convertido com animação
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF82E0AA).withOpacity(0.8),
                    const Color(0xFF58D68D).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Valor Convertido',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Watch(
                    (context) => Text(
                      currencyConverterController.amountConverted.value
                          .toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
