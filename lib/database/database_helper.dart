import 'package:expense_manager/models/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _table = 'transactions';
  static Database? _db;

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'expenzia.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
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
      },
    );
  }

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

  Future<int> deleteAll() async {
    final db = await database;
    return db.delete(_table);
  }
}