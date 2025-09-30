import 'package:currency_tracker/core/theme/app_theme.dart';
import 'package:currency_tracker/core/utils/currency_utils.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/di/injector.dart';
import '../viewmodels/currency_list_viewmodel.dart';
import '../widgets/currency_carousel.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  late final CurrencyListController viewController;
  late final void Function() _disposeSnackEffect;

  @override
  void initState() {
    super.initState();
    viewController = injector.get<CurrencyListController>();
    viewController.loadCurrencies();

    _disposeSnackEffect = effect(() {
      final message = viewController.snackMessage.value;
      if (message != null && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          final isRemoveMessage = message.contains('removida.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 3),
              action: isRemoveMessage
                  ? SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        viewController.undoRemove();
                      },
                    )
                  : null,
              backgroundColor: viewController.errorMessage.value != null
                  ? Theme.of(context).colorScheme.error
                  : !AppTheme.currentMode(context)
                      ? Theme.of(context).colorScheme.secondary
                      : null,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
          viewController.clearSnackMessage();
        });
      }
    });
  }

  @override
  void dispose() {
    _disposeSnackEffect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Watch(
          (context) {
            var currencies = viewController.currencies.value;
            return CurrencyCarousel(
              currencies: currencies,
              onFavoriteToggle: viewController.toggleFavorite,
              onCurrencyChanged: (currencyCode) {
                viewController.loadQuotesForCurrency(currencyCode);
              },
              onAddCurrency: (newCurrency) async {
                await viewController.addCurrency(newCurrency);
              },
              onUpdateCurrency: (updatedCurrency) async {
                await viewController.updateCurrency(updatedCurrency);
              },
              addCurrencyCommand: viewController.addCurrencyCommand,
              updateCurrencyCommand: viewController.updateCurrencyCommand,
              onRemoveCurrency: viewController.removeCurrency,
            );
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Watch(
            (context) {
              final quotes = viewController.quotes.value;

              if (viewController.isExecuting.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewController.errorMessage.value != null) {
                return Center(child: Text(viewController.errorMessage.value!));
              }

              if (quotes.isEmpty) return noHistoricalQuoteWidget(context);

              final scrollController = ScrollController();

              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    final date = DateTime.fromMillisecondsSinceEpoch(
                      quote.timestamp,
                    ).toLocal();

                    final formattedDate =
                        "${date.day.toString().padLeft(2, '0')}/"
                        "${date.month.toString().padLeft(2, '0')}/"
                        "${date.year} ${date.hour.toString().padLeft(2, '0')}:"
                        "${date.minute.toString().padLeft(2, '0')}";

                    final backgroundColor = index % 2 != 0
                        ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withAlpha(50)
                        : Theme.of(context).colorScheme.secondary.withAlpha(30);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade400,
                          child: Text(
                            quote.currencyCode[0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          '${quote.currencyCode}: ${CurrencyUtils.getCurrencySymbol(quote.currencyCode)} ${quote.quoteValue.toStringAsFixed(4)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(formattedDate),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget noHistoricalQuoteWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.history,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            'Sem cotações históricas registradas',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
