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
import 'package:plantation/utils/const.dart';

class DbQueries {
  static void createTables() {
    DatabaseHelper().opendb().then((db) {
      db!.execute(createDistrictTable());
      db.execute(createBlockTable());
      db.execute(createVillageTable());
      db.execute(createFarmerTable());
      db.execute(createStageTable());
      db.execute(createFYRTable());
      db.execute(createFruitTree());
      db.execute(createForestTree());
      db.execute(createDemandTable());
    });
  }

  static void dropTables() {
    DatabaseHelper().opendb().then((db) {
      db!.execute(dropDemandTable());
      db.execute(dropFYRTable());
      db.execute(dropStageTable());
      db.execute(dropForestTree());
      db.execute(dropFruitTree());
      db.execute(dropFarmerTable());
      db.execute(dropVillageTable());
      db.execute(dropBlockTable());
      db.execute(dropDistrictTable());
    });
  }

  static void initTables(Database db) {
    db.execute(createDistrictTable());
    db.execute(createBlockTable());
    db.execute(createVillageTable());
    db.execute(createFarmerTable());
    db.execute(createStageTable());
    db.execute(createFYRTable());
    db.execute(createFruitTree());
    db.execute(createForestTree());
    db.execute(createDemandTable());
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
      db.rawUpdate(
          "update farmer_year_reg set stage=2 where reg_id = ${obj.regId}");
    });
  }

  static deleteDemand(int id) async {
    DatabaseHelper().opendb().then((db) {
      db!.rawUpdate(
          "update farmer_year_reg set stage=1 where reg_id = (select reg_id from demand where demand_id = $id)");
      db.delete('demand', where: 'demand_id = ?', whereArgs: [id]);
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

  Future resetDatabase() async {
    DbQueries.dropTables();
    DbQueries.createTables();
  }
}
