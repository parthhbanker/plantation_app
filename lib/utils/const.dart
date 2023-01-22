// table string
String createDistrictTable() {
  return "CREATE TABLE IF NOT EXISTS district(district_id INTEGER PRIMARY KEY , district_name TEXT, status INTEGER)";
}

String createBlockTable() {
  return "CREATE TABLE IF NOT EXISTS block(block_id INTEGER PRIMARY KEY , block_name TEXT, district_id INTEGER, status INTEGER, FOREIGN KEY (district_id) REFERENCES district(district_id))";
}

String createVillageTable() {
  return "CREATE TABLE IF NOT EXISTS village(village_id INTEGER PRIMARY KEY , village_name TEXT, block_id INTEGER, status INTEGER, FOREIGN KEY (block_id) REFERENCES block(block_id))";
}

String createFarmerTable() {
  return "CREATE TABLE IF NOT EXISTS farmer(farmer_id INTEGER PRIMARY KEY , name TEXT,phone TEXT, aadhar TEXT, sex INTEGER, village_id INTEGER, status INTEGER, FOREIGN KEY (village_id) REFERENCES village(village_id))";
}

String createStageTable() {
  return "CREATE TABLE IF NOT EXISTS stage(stage_id INTEGER PRIMARY KEY, stage TEXT)";
}

String createFYRTable() {
  return "CREATE TABLE IF NOT EXISTS farmer_year_reg(reg_id INTEGER PRIMARY KEY, farmer_id INTEGER, reg_year TEXT, stage INTEGER, FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id), FOREIGN KEY (stage) REFERENCES stage(stage_id))";
}

String createForestTree() {
  return "CREATE TABLE IF NOT EXISTS forest_tree(id INTEGER PRIMARY KEY, tree_name TEXT, status INTEGER)";
}

String createFruitTree() {
  return "CREATE TABLE IF NOT EXISTS fruit_tree(id INTEGER PRIMARY KEY, tree_name TEXT, status INTEGER)";
}

String createDemandTable() {
  return "CREATE TABLE IF NOT EXISTS demand(demand_id INTEGER PRIMARY KEY AUTOINCREMENT, reg_id INTEGER, surveyor_id INTEGER, forest_tree TEXT, fruit_tree TEXT, farmer_img TEXT, farmer_sign TEXT, surveyor_sign TEXT, demand_date TEXT, location TEXT)";
}

// drop table string
String dropDistrictTable() {
  return "DROP TABLE IF  EXISTS district";
}

String dropBlockTable() {
  return "DROP TABLE IF  EXISTS block";
}

String dropVillageTable() {
  return "DROP TABLE IF  EXISTS village";
}

String dropFarmerTable() {
  return "DROP TABLE IF  EXISTS farmer";
}

String dropStageTable() {
  return "DROP TABLE IF  EXISTS stage";
}

String dropFYRTable() {
  return "DROP TABLE IF  EXISTS farmer_year_reg";
}

String dropForestTree() {
  return "DROP TABLE IF  EXISTS forest_tree";
}

String dropFruitTree() {
  return "DROP TABLE IF  EXISTS fruit_tree";
}

String dropDemandTable() {
  return "DROP TABLE IF  EXISTS demand";
}
