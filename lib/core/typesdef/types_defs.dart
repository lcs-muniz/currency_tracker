import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';
import 'package:flutter/foundation.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void,Failure>;
typedef CurrencyResult = Result<Currency,Failure>;
typedef CurrencyListResult = Result<List<Currency>,Failure>;
typedef HistoricalQuotesResult = Result<List<HistoricalQuote>,Failure>;
//typedef CompleteWeatherResult = Result<(Weather, List<WeatherForecast>),Failure>;

// typedfs para parâmetros
//typedef CoordinatesParams = ({@required double lat, @required double lon});
typedef NoParams = ();
typedef CurrencyParams = ({@required Currency currency});
typedef CodeCurrencyParams = ({@required String code});
