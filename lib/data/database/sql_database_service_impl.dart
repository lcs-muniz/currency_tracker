import 'package:sqflite/sqflite.dart';
import 'package:currency_tracker/core/patterns/result.dart';
import 'package:currency_tracker/core/failures/failure.dart';
import 'package:currency_tracker/core/messages/app_messages.dart';
import 'package:currency_tracker/core/typesdef/types_defs.dart';
import 'package:currency_tracker/data/database/sql_database_connection.dart';
import 'package:currency_tracker/domain/entities/currency.dart';
import 'package:currency_tracker/domain/entities/historical_quote.dart';
import 'package:currency_tracker/domain/mapper/currency_mapper.dart';
import 'package:currency_tracker/domain/mapper/historical_quotes_mapper.dart';
import 'i_database_service.dart';

class SqlDatabaseServiceImpl implements IDatabaseService {
  Database? _database;

  Future<Database> get database async {
    _database ??= await SqlDatabaseConnection.init();
    return _database!;
  }

  // ---------- Currency ----------

  @override
  Future<VoidResult> insertCurrency(Currency currency) async {
    try {
      final db = await database;
      final rowId = await db.insert(
        'currencies',
        CurrencyMapper.toMap(currency),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (rowId <= 0) {
        return Error(DatabaseInsertFailure(
            '${AppMessages.error.databaseInsertError}: Ao Inserir Moeda'));
      }
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Inserir Moeda - $e'));
    }
  }

  @override
  Future<VoidResult> updateCurrency(Currency currency) async {
    try {
      final db = await database;
      final result = await db.update(
        'currencies',
        CurrencyMapper.toMap(currency),
        where: 'code = ?',
        whereArgs: [currency.code],
      );
      if (result == 0) {
        return Error(DatabaseUpdateFailure(
            '${AppMessages.error.databaseUpdateError}: Moeda não encontrada'));
      }
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Atualizar Moeda - $e'));
    }
  }

  @override
  Future<VoidResult> deleteCurrency(String code) async {
    try {
      final db = await database;
      final result = await db.delete(
        'currencies',
        where: 'code = ?',
        whereArgs: [code],
      );
      if (result == 0) {
        return Error(DatabaseDeleteFailure(
            '${AppMessages.error.databaseDeleteError}: Moeda não encontrada'));
      }
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Excluir Moeda - $e'));
    }
  }

  @override
  Future<CurrencyListResult> getCurrencies() async {
    try {
      final db = await database;
      final maps = await db.query('currencies');

      
      if (maps.isEmpty) {
        return const Success([]);
      }
      
      // if (maps.isEmpty) {
      //   return Error(DatabaseQueryFailure(
      //       '${AppMessages.error.databaseQueryError}: Nenhuma moeda encontrada'));
      // }
      final currencies = maps.map(CurrencyMapper.fromMap).toList();
      return Success(currencies);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Buscar Moedas - $e'));
    }
  }

  @override
  Future<CurrencyResult> getCurrency(String code) async {
    try {
      final db = await database;
      final maps = await db.query(
        'currencies',
        where: 'code = ?',
        whereArgs: [code],
      );
      if (maps.isEmpty) {
        return Error(DatabaseQueryFailure(
            '${AppMessages.error.databaseQueryError}: Moeda não encontrada'));
      }
      final currency = CurrencyMapper.fromMap(maps.first);
      return Success(currency);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Buscar Moeda - $e'));
    }
  }

  @override
  Future<CurrencyListResult> getFavoriteCurrencies() async {
    try {
      final db = await database;
      final maps = await db.query(
        'currencies',
        where: 'is_favorite = ?',
        whereArgs: [1],
      );
      if (maps.isEmpty) {
        return Error(DatabaseQueryFailure(
            '${AppMessages.error.databaseQueryError}: Nenhuma moeda favorita encontrada'));
      }
      final currencies = maps.map(CurrencyMapper.fromMap).toList();
      return Success(currencies);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Buscar Favoritos - $e'));
    }
  }

  // ---------- HistoricalQuote ----------

  @override
  Future<HistoricalQuotesResult> getHistoricalQuotes(
      String currencyCode) async {
    try {
      final db = await database;
      final maps = await db.query(
        'historical_quotes',
        where: 'currency_code = ?',
        whereArgs: [currencyCode],
      );
      if (maps.isEmpty) {
        return Error(DatabaseQueryFailure(
            '${AppMessages.error.databaseQueryError}: Nenhum histórico encontrado'));
      }
      final historicalQuotes = maps.map(HistoricalQuoteMapper.fromMap).toList();
      return Success(historicalQuotes);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Buscar Histórico - $e'));
    }
  }

  @override
  Future<VoidResult> insertHistoricalQuote(HistoricalQuote quote) async {
    try {
      final db = await database;
      final rowId = await db.insert(
        'historical_quotes',
        HistoricalQuoteMapper.toMap(quote),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (rowId <= 0) {
        return Error(DatabaseInsertFailure(
            '${AppMessages.error.databaseInsertError}: Ao Inserir Histórico'));
      }
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(
          '${AppMessages.error.databaseError}: Ao Inserir Histórico - $e'));
    }
  }
}
