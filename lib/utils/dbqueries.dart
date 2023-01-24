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
    DatabaseHelper().opendb().then((db) async {
      var batch = db!.batch();
      batch.execute(createDistrictTable());
      batch.execute(createBlockTable());
      batch.execute(createVillageTable());
      batch.execute(createFarmerTable());
      batch.execute(createStageTable());
      batch.execute(createFYRTable());
      batch.execute(createFruitTree());
      batch.execute(createForestTree());
      batch.execute(createDemandTable());
      await batch.commit(noResult: true);
    });
  }

  static void dropTables() {
    DatabaseHelper().opendb().then((db) async {
      var batch = db!.batch();
      batch.execute(dropDemandTable());
      batch.execute(dropFYRTable());
      batch.execute(dropStageTable());
      batch.execute(dropForestTree());
      batch.execute(dropFruitTree());
      batch.execute(dropFarmerTable());
      batch.execute(dropVillageTable());
      batch.execute(dropBlockTable());
      batch.execute(dropDistrictTable());
      await batch.commit(noResult: true);
    });
  }

  static void initTables(Database db) async {
    var batch = db.batch();
    batch.execute(createDistrictTable());
    batch.execute(createBlockTable());
    batch.execute(createVillageTable());
    batch.execute(createFarmerTable());
    batch.execute(createStageTable());
    batch.execute(createFYRTable());
    batch.execute(createFruitTree());
    batch.execute(createForestTree());
    batch.execute(createDemandTable());
    await batch.commit(noResult: true);
  }

  // add data to tables
  static void addDistrictData(DistrictModel d) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('district', d.toJson());
      });
    });
  }

  static void addBlockData(BlockModel b) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('block', b.toJson());
      });
    });
  }

  static void addVillageData(VillageModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      db!.transaction((txn) async {
        return await txn.insert('village', obj.toJson());
      });
    });
  }

  static void addFarmerData(FarmerModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('farmer', obj.toJson());
      });
    });
  }

  static void addStageData(StageModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('stage', obj.toJson());
      });
    });
  }

  static void addFYRData(FarmerRegModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('farmer_year_reg', obj.toJson());
      });
    });
  }

  static void addForestTreeData(ForestTreeModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('forest_tree', obj.toJson());
      });
    });
  }

  static void addFruitTreeData(FruitTreeModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return await txn.insert('fruit_tree', obj.toJson());
      });
    });
  }

  static addDemandData(DemandModel obj) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return txn.insert('demand', obj.toJson());
      });
      await db.transaction((txn) async {
        return txn.rawUpdate(
            "update farmer_year_reg set stage=2 where reg_id = ${obj.regId}");
      });
    });
  }

  static deleteDemand(int id) async {
    DatabaseHelper().opendb().then((db) async {
      await db!.transaction((txn) async {
        return txn.rawUpdate(
            "update farmer_year_reg set stage=1 where reg_id = (select reg_id from demand where demand_id = $id)");
      });
      await db.transaction((txn) async {
        return txn.delete('demand', where: 'demand_id = ?', whereArgs: [id]);
      });
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
