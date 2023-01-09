import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Body.dart';

class DB{
  static const String _dbname = 'Data.db';
  static late Database database;

  static Future init() async{
    String path = join(await getDatabasesPath(), _dbname);
    database = await openDatabase(
      path,
      onCreate:(db, version) => _createdb(db, version),
      version: 1,
    );
  }

  static Future _createdb(Database db, int version) async{
    String sql;
    sql = "create table body(height real, weight real, bmi real, date text primary key, action int)";
    db.execute(sql);
  }

  static Future clear() async{
    final db = await database;
    db.close();
    String path = join(await getDatabasesPath(), _dbname);
    await deleteDatabase(path);
  }

  static Future<List<Map<String, dynamic>>> getBody() async{
    List<Map<String, dynamic>> data = [];
    final db = await database;
    if(db.isOpen){
      data = await db.query("body");
    }
    return data;
  }

  static Future insert(Body b) async{
    final db = await database;
    if(db.isOpen){
      db.insert('body', b.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future setDBAction(Body b) async{
    final db = await database;
    Map<String, dynamic> m = b.toMap();
    if(db.isOpen){
      await db.update(
          'body',
          b.toMap(),
          where: 'date = ?',
          whereArgs: [b.date]
      );
    }
  }

  static Future delete(Body b) async{
    final db = await database;
    if(db.isOpen){
      await db.delete(
          'body',
          where: 'date = ?',
          whereArgs: [b.date]
      );
    }
  }

}