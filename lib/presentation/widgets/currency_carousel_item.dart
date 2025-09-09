import 'package:flutter/material.dart';

import '../../domain/entities/currency.dart';
import 'currency_card.dart';

class CurrencyCarouselItem extends StatelessWidget {
  final Currency currency;
  final Future<void> Function(String code)? onFavoriteToggle;
  final VoidCallback? onTap; // callback para abrir modal


  const CurrencyCarouselItem(
      {super.key, required this.currency, this.onFavoriteToggle, this.onTap});

  @override
  Widget build(BuildContext context) {
    //final addFavoriteCommand = injector.get<AddFavoriteCommand>();

    return GestureDetector(
      onDoubleTap: onTap,
      child: CurrencyCard(
        currency: currency,
        onFavoriteChanged: (isFavorite) {
          if (isFavorite != null) {
            onFavoriteToggle?.call(currency.code);
          }
        },
        
        // onHistoricalQuotesPressed: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           HistoricalQuotesPage(currencyCode: currency.code),
        //     ),
        //   );
        // },
      ),
    );
  }
}
