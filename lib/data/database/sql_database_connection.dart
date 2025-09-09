
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDatabaseConnection {
  static const _dbName = 'currency_tracker.db';
  static const _dbVersion = 1;

  /// Abre ou cria o banco de dados
  static Future<Database> init() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  /// Cria as tabelas na inicialização
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE currencies(
        code TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        is_favorite INTEGER NOT NULL,
        latest_quote REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE historical_quotes(
        currency_code TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        quote_value REAL NOT NULL,
        PRIMARY KEY (currency_code, timestamp),
        FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE CASCADE
      )
    ''');
  }

}