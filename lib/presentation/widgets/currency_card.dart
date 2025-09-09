import 'package:currency_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';

class CurrencyCard extends StatelessWidget {
  final Currency currency;
  final ValueChanged<bool?>? onFavoriteChanged;
  // final VoidCallback? onHistoricalQuotesPressed;

  const CurrencyCard({
    super.key,
    required this.currency,
    this.onFavoriteChanged,
    // this.onHistoricalQuotesPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = currency.isFavorite;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: !AppTheme.currentMode(context)
            ? theme.colorScheme.surface
            : theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: isFavorite
            ? Border.all(color: theme.colorScheme.secondary, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações da moeda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currency.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currency.code,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Cotação e ações
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$ ${currency.latestQuote.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   icon: const Icon(Icons.history),
                          //   color: theme.colorScheme.primary,
                          //   tooltip: 'Ver Histórico',
                          //   onPressed: onHistoricalQuotesPressed,
                          //   visualDensity: VisualDensity.compact,
                          // ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: isFavorite
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                            ),
                            tooltip: isFavorite
                                ? 'Remover dos favoritos'
                                : 'Adicionar aos favoritos',
                            onPressed: () =>
                                onFavoriteChanged?.call(!currency.isFavorite),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
              // Mensagem de toque duplo
              Text(
                'Toque duplo para editar',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
