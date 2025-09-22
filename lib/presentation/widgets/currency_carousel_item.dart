import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/currency.dart';
import 'currency_card.dart';

class CurrencyCarouselItem extends StatefulWidget {
  final Currency currency;
  final Future<void> Function(String code)? onFavoriteToggle;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const CurrencyCarouselItem({
    super.key,
    required this.currency,
    this.onFavoriteToggle,
    this.onTap,
    this.onRemove,
  });

  @override
  State<CurrencyCarouselItem> createState() => _CurrencyCarouselItemState();
}

class _CurrencyCarouselItemState extends State<CurrencyCarouselItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final Duration _deleteHoldDuration = const Duration(seconds: 2);

  Timer? _startAnimationTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _deleteHoldDuration,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onRemove?.call();
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _startAnimationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _handlePressDown(TapDownDetails details) {
    // Inicia um timer. Se o usuário não soltar o dedo, a animação começará.
    _startAnimationTimer = Timer(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  void _handlePressUp(TapUpDetails details) {
    _startAnimationTimer?.cancel();
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  void _handlePressCancel() {
    _startAnimationTimer?.cancel();
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onTap,
      onTapDown: _handlePressDown,
      onTapUp: _handlePressUp,
      onTapCancel: _handlePressCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final progress = _animationController.value;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CurrencyCard(
                currency: widget.currency,
                onFavoriteChanged: (isFavorite) {
                  if (isFavorite != null) {
                    widget.onFavoriteToggle?.call(widget.currency.code);
                  }
                },
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(progress * 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: progress > 0.3
                          ? Icon(
                              Icons.delete_forever,
                              color: Colors.white.withOpacity(progress * 0.8),
                              size: 48,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
