import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/credit_model.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _table = 'transactions';
  static const _creditTable = 'credits';
  static Database? _db;

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'expenzia.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTransactions(db);
        await _createCredits(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createCredits(db);
      },
    );
  }

  Future<void> _createTransactions(Database db) => db.execute('''
        CREATE TABLE $_table(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          description TEXT
        )
      ''');

  Future<void> _createCredits(Database db) => db.execute('''
        CREATE TABLE $_creditTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          credit_type TEXT NOT NULL,
          name TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL,
          plan_type TEXT NOT NULL
        )
      ''');

  // ---------- Transactions ----------

  // CREATE
  Future<int> insert(TransactionModel t) async {
    final db = await database;
    final map = t.toMap()..remove('id');
    return db.insert(_table, map);
  }

  // READ
  Future<List<TransactionModel>> getAll() async {
    final db = await database;
    final rows = await db.query(_table, orderBy: 'date DESC, id DESC');
    return rows.map(TransactionModel.fromMap).toList();
  }

  // UPDATE
  Future<int> update(TransactionModel t) async {
    final db = await database;
    return db.update(_table, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Clears both tables (used by "Clear Storage").
  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(_table);
    await db.delete(_creditTable);
  }

  // ---------- Credits ----------

  Future<int> insertCredit(CreditModel c) async {
    final db = await database;
    final map = c.toMap()..remove('id');
    return db.insert(_creditTable, map);
  }

  Future<List<CreditModel>> getAllCredits() async {
    final db = await database;
    final rows = await db.query(_creditTable, orderBy: 'id DESC');
    return rows.map(CreditModel.fromMap).toList();
  }

  Future<int> deleteCredit(int id) async {
    final db = await database;
    return db.delete(_creditTable, where: 'id = ?', whereArgs: [id]);
  }
}