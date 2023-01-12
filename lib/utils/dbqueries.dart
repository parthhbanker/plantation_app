import 'package:plantation/utils/dbhelper.dart';
import 'package:plantation/api/api.dart';

class DbQueries {
  static void createTables() {
    DatabaseHelper().opendb().then((db) {
      db!.execute(DbQueries._createDistrictTable());
      db.execute(DbQueries._createBlockTable());
      db.execute(DbQueries._createVillageTable());
      db.execute(DbQueries._createFarmerTable());
    });
  }

  // function to create district table
  static String _createDistrictTable() {
    return "CREATE TABLE IF NOT EXISTS district(id INTEGER PRIMARY KEY , name TEXT)";
  }

  // function to create subdistrict table
  static String _createBlockTable() {
    return "CREATE TABLE IF NOT EXISTS block(id INTEGER PRIMARY KEY , name TEXT, district_id INTEGER, FOREIGN KEY (district_id) REFERENCES district(id))";
  }

  // function to create village table
  static String _createVillageTable() {
    return "CREATE TABLE IF NOT EXISTS village(id INTEGER PRIMARY KEY , name TEXT, block_id INTEGER, FOREIGN KEY (block_id) REFERENCES block(id))";
  }

  // function to create farmer table
  static String _createFarmerTable() {
    return "CREATE TABLE IF NOT EXISTS farmer(id INTEGER PRIMARY KEY , name TEXT, village_id INTEGER, FOREIGN KEY (village_id) REFERENCES village(id))";
  }
}
