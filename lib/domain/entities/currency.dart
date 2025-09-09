import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String name;
  final String code;
  final bool isFavorite;
  final double latestQuote;

  const Currency({
    required this.name,
    required this.code,
    required this.isFavorite,
    required this.latestQuote,
  });

  @override
  List<Object?> get props => [name, code, isFavorite, latestQuote];

  Currency copyWith({
    String? name,
    String? code,
    bool? isFavorite,
    double? latestQuote,
  }) {
    return Currency(
      name: name ?? this.name,
      code: code ?? this.code,
      isFavorite: isFavorite ?? this.isFavorite,
      latestQuote: latestQuote ?? this.latestQuote,
    );
  }
}
