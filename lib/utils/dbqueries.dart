import 'package:plantation/models/block_model.dart';
import 'package:plantation/models/demand_model.dart';
import 'package:plantation/models/district_model.dart';
import 'package:plantation/models/farmer_model.dart';
import 'package:plantation/models/farmer_reg_model.dart';
import 'package:plantation/models/forest_tree_model.dart';
import 'package:plantation/models/fruit_tree_model.dart';
import 'package:plantation/models/stage_model.dart';
import 'package:plantation/models/village_model.dart';
import 'package:plantation/utils/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class DbQueries {
  static void createTables() {
    DatabaseHelper().opendb().then((db) {
      db!.execute(DbQueries._createDistrictTable());
      db.execute(DbQueries._createBlockTable());
      db.execute(DbQueries._createVillageTable());
      db.execute(DbQueries._createFarmerTable());
      db.execute(DbQueries._createStageTable());
      db.execute(DbQueries._createFYRTable());
      db.execute(DbQueries._createFruitTree());
      db.execute(DbQueries._createForestTree());
      db.execute(DbQueries._createDemandTable());
    });
  }

  static void initTables(Database db) {
    db.execute(DbQueries._createDistrictTable());
    db.execute(DbQueries._createBlockTable());
    db.execute(DbQueries._createVillageTable());
    db.execute(DbQueries._createFarmerTable());
    db.execute(DbQueries._createStageTable());
    db.execute(DbQueries._createFYRTable());
    db.execute(DbQueries._createFruitTree());
    db.execute(DbQueries._createForestTree());
    db.execute(DbQueries._createDemandTable());
  }

  // table string
  static String _createDistrictTable() {
    return "CREATE TABLE IF NOT EXISTS district(district_id INTEGER PRIMARY KEY , district_name TEXT, status INTEGER)";
  }

  static String _createBlockTable() {
    return "CREATE TABLE IF NOT EXISTS block(block_id INTEGER PRIMARY KEY , block_name TEXT, district_id INTEGER, status INTEGER, FOREIGN KEY (district_id) REFERENCES district(district_id))";
  }

  static String _createVillageTable() {
    return "CREATE TABLE IF NOT EXISTS village(village_id INTEGER PRIMARY KEY , village_name TEXT, block_id INTEGER, status INTEGER, FOREIGN KEY (block_id) REFERENCES block(block_id))";
  }

  static String _createFarmerTable() {
    return "CREATE TABLE IF NOT EXISTS farmer(farmer_id INTEGER PRIMARY KEY , name TEXT,phone TEXT, aadhar TEXT, sex INTEGER, village_id INTEGER, status INTEGER, FOREIGN KEY (village_id) REFERENCES village(village_id))";
  }

  static String _createStageTable() {
    return "CREATE TABLE IF NOT EXISTS stage(stage_id INTEGER PRIMARY KEY, stage TEXT)";
  }

  static String _createFYRTable() {
    return "CREATE TABLE IF NOT EXISTS farmer_year_reg(reg_id INTEGER PRIMARY KEY, farmer_id INTEGER, reg_year TEXT, stage INTEGER, FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id), FOREIGN KEY (stage) REFERENCES stage(stage_id))";
  }

  static String _createForestTree() {
    return "CREATE TABLE IF NOT EXISTS forest_tree(id INTEGER PRIMARY KEY, tree_name TEXT, status INTEGER)";
  }

  static String _createFruitTree() {
    return "CREATE TABLE IF NOT EXISTS fruit_tree(id INTEGER PRIMARY KEY, tree_name TEXT, status INTEGER)";
  }

  static String _createDemandTable() {
    return "CREATE TABLE IF NOT EXISTS demand(demand_id INTEGER PRIMARY KEY AUTOINCREMENT, reg_id INTEGER, surveyor_id INTEGER, forest_tree TEXT, fruit_tree TEXT, farmer_img TEXT, farmer_sign TEXT, surveyor_sign TEXT, demand_date TEXT)";
  }

  // add data to tables
  static void addDistrictData(DistrictModel d) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('district', d.toJson());
    });
  }

  static void addBlockData(BlockModel b) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('block', b.toJson());
    });
  }

  static void addVillageData(VillageModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('village', obj.toJson());
    });
  }

  static void addFarmerData(FarmerModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('farmer', obj.toJson());
    });
  }

  static void addStageData(StageModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('stage', obj.toJson());
    });
  }

  static void addFYRData(FarmerRegModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('farmer_year_reg', obj.toJson());
    });
  }

  static void addForestTreeData(ForestTreeModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('forest_tree', obj.toJson());
    });
  }

  static void addFruitTreeData(FruitTreeModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('fruit_tree', obj.toJson());
    });
  }

  static addDemandData(DemandModel obj) async {
    DatabaseHelper().opendb().then((db) {
      db!.insert('demand', obj.toJson());
      // db.rawUpdate(
      //     "update farmer_year_reg set stage=2 where reg_id = ${obj.regId}");
    });
  }

  static deleteDemand(int id) async {
    DatabaseHelper().opendb().then((db) {
      db!.delete('demand', where: 'demand_id = ?', whereArgs: [id]);
    });
  }

  //
  Future<List<dynamic>> getDBData({required String tableName}) async {
    Database? db = await DatabaseHelper().opendb();

    List data;

    data = await db!.query(tableName);
    return data;
  }

  Future<List<dynamic>> fetchCustomQuery({required String query}) async {
    Database? db = await DatabaseHelper().opendb();

    return db!.rawQuery(query);
  }
}
