import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> opendb() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'plantation.db'),
    );
    return _db;
  }
}
