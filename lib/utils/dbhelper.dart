import 'package:plantation/api/api.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> opendb() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'plantation.db'),
      onCreate: (db, version) {
        DbQueries.initTables(db);
        ApiHandler.fetchApiData();
        return;
      },
      version: 1,
    );
    return _db;
  }
}
