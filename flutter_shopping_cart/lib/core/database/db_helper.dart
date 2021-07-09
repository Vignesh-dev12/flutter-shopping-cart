import 'dart:convert';
import 'package:flutter_shopping_cart/ui/routes/login_and_register/model/login_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_statics.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static DbStatics? _dbStatics;

  DataBaseHelper._createInstance();

  static Database? _database;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper!;
  }

  get dbStatics {
    if (_dbStatics == null) {
      _dbStatics = DbStatics();
    }
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String directoryPath = join(await getDatabasesPath(), 'connect.db');
    var bookDataBase = openDatabase(directoryPath,
        version: 2, onCreate: _createTable, onUpgrade: _upgradeTable);
    return bookDataBase;
  }

  void _createTable(Database db, int newVersion) async {
    await db.execute(DbStatics.createUsersTable);
  }

  void _upgradeTable(Database db, int newVersion, int oldVersion) async {}

  Future<bool> checkUserIfAlreadyExists(String name, String dateOfBirth) async {
    var map = await (await database).query(DbStatics.tableUsers,
        where: '${DbStatics.userName} = ? AND ${DbStatics.userDataOfBirth} = ?',
        whereArgs: [name, dateOfBirth]);
    return map.isNotEmpty ? true : false;
  }

  Future<User?> login(String name, String password) async {
    final Database database = await this.database;
    final maps = await database.query(DbStatics.tableUsers,
        where: '${DbStatics.userName} = ? AND ${DbStatics.userPassword} = ?',
        whereArgs: [name, password]);
    print('DbHelper :: getCollectionBook() :: ${jsonEncode(maps)}');
    List<User> list =
        maps.isNotEmpty ? maps.map((e) => User.fromJson(e)).toList() : [];
    return list.isNotEmpty ? list.first : null;
  }

  Future insert(String tableName, Map<String, dynamic> map) async {
    //showLog('DbHelper :: INSERT :: TABLE => $tableName :: VALUES => $map');
    (await database)
        .insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
