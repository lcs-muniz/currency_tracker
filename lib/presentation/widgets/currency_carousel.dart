import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:currency_tracker/core/theme/app_theme.dart';
import 'package:currency_tracker/presentation/widgets/currency_sheet.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/currency.dart';
import 'currency_carousel_item.dart';

class CurrencyCarousel extends StatefulWidget {
  final List<Currency> currencies;
  final Future<void> Function(String code)? onFavoriteToggle;
  final void Function(String currencyCode)? onCurrencyChanged;
  final FlutterComputed<bool> isExecuting;

  // Callbacks para adicionar ou editar moeda
  final Future<void> Function(Currency newCurrency)? onAddCurrency;
  final Future<void>Function(Currency updatedCurrency)? onUpdateCurrency;

  const CurrencyCarousel({
    super.key,
    required this.currencies,
    this.onFavoriteToggle,
    this.onCurrencyChanged,
    this.onAddCurrency,
    this.onUpdateCurrency,
    required this.isExecuting,
  });

  @override
  State<CurrencyCarousel> createState() => _CurrencyCarouselState();
}

class _CurrencyCarouselState extends State<CurrencyCarousel> {
  final _carouselController = slider.CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Lista com moedas + um card extra para "Adicionar"
    final allItems = [
      ...widget.currencies.map(
        (currency) => CurrencyCarouselItem(
          currency: currency,
          onFavoriteToggle: widget.onFavoriteToggle,
          onTap: () {
            CurrencySheet.show(
              context: context,
              currency: currency,
              onSubmit: widget.onUpdateCurrency!,
              isExecuting: widget.isExecuting,
            );
          },
        ),
      ),
      _buildAddCurrencyCard(theme),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carrossel
        slider.CarouselSlider(
          carouselController: _carouselController,
          options: slider.CarouselOptions(
            height: 200.0,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });

              // Notifica mudança de moeda apenas se não for o card de adicionar
              if (widget.onCurrencyChanged != null &&
                  index < widget.currencies.length) {
                final selectedCurrency = widget.currencies[index].code;
                widget.onCurrencyChanged!(selectedCurrency);
              }
            },
          ),
          items: allItems,
        ),

        const SizedBox(height: 12),

        // Indicadores (dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(allItems.length, (index) {
            final isActive = _currentIndex == index;
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(index),
              child: Container(
                width: isActive ? 12.0 : 8.0,
                height: isActive ? 12.0 : 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Card para adicionar nova moeda
  Widget _buildAddCurrencyCard(ThemeData theme) {
    var color = AppTheme.currentMode(context)
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        CurrencySheet.show(
          context: context,
          onSubmit: widget.onAddCurrency!,
          isExecuting: widget.isExecuting,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                'Adicionar moeda',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
