import 'package:equatable/equatable.dart';

class HistoricalQuote extends Equatable {
  final String currencyCode;
  final double quoteValue;
  final int timestamp;

  const HistoricalQuote({
    required this.currencyCode,
    required this.quoteValue,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [currencyCode, quoteValue, timestamp];
}
