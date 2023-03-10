import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:plantation/api/const.dart';
import 'package:plantation/models/block_model.dart';
import 'package:plantation/models/demand_model.dart';
import 'package:plantation/models/district_model.dart';
import 'package:plantation/models/farmer_model.dart';
import 'package:plantation/models/farmer_reg_model.dart';
import 'package:plantation/models/forest_tree_model.dart';
import 'package:plantation/models/fruit_tree_model.dart';
import 'package:plantation/models/stage_model.dart';
import 'package:plantation/models/village_model.dart';
import 'package:plantation/utils/dbqueries.dart';

class ApiHandler {
  static Future<void> _fetchDistrictData() async {
    final response = await http.get(Uri.parse(districtUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map((d) => {DbQueries.addDistrictData(DistrictModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchBlockData() async {
    final response = await http.get(Uri.parse(blockUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map((d) => {DbQueries.addBlockData(BlockModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchVillageData() async {
    final response = await http.get(Uri.parse(villageUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map(
            (d) => {
              DbQueries.addVillageData(
                VillageModel.fromJson(d),
              ),
            },
          )
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchStageData() async {
    final response = await http.get(Uri.parse(stageUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map((d) => {DbQueries.addStageData(StageModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchFYRData() async {
    final response = await http.get(Uri.parse(farmerRegUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map(
            (d) => {
              DbQueries.addFYRData(
                FarmerRegModel.fromJson(d),
              ),
            },
          )
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchFarmerData() async {
    final response = await http.get(Uri.parse(farmerUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map((d) => {DbQueries.addFarmerData(FarmerModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchForestData() async {
    final response = await http.get(Uri.parse(forestTreeUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map(
              (d) => {DbQueries.addForestTreeData(ForestTreeModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> _fetchFruitData() async {
    final response = await http.get(Uri.parse(fruitTreeUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      (data as List)
          .map((d) => {DbQueries.addFruitTreeData(FruitTreeModel.fromJson(d))})
          .toList();
    }
    return jsonDecode(response.body);
  }

  static Future<void> sendDemandData(DemandModel obj) async {
    final request = http.MultipartRequest(
      'post',
      Uri.parse(addDemandUrl),
    );

    http.MultipartFile farmerSignMultipart =
        await http.MultipartFile.fromPath('farmer_sign', obj.farmerSign);
    http.MultipartFile farmerImageMultipart =
        await http.MultipartFile.fromPath('farmer_image', obj.farmerImage);
    http.MultipartFile surveyorSignMultipart =
        await http.MultipartFile.fromPath('surveyor_sign', obj.surveyorSign);

    request.files.add(farmerSignMultipart);
    request.files.add(farmerImageMultipart);
    request.files.add(surveyorSignMultipart);

    request.fields['demand_date'] = obj.demandDate;
    request.fields['reg_id'] = obj.regId.toString();
    request.fields['forest_tree'] = jsonEncode(obj.forestTree).toString();
    request.fields['fruit_tree'] = jsonEncode(obj.fruitTree).toString();
    request.fields['surveyor_id'] = obj.surveyorId.toString();
    request.fields['location'] = obj.location.toString();

    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Data added");
    }
  }

  // master function to call each fetch function
  static void fetchApiData() {
    ApiHandler._fetchDistrictData();
    ApiHandler._fetchBlockData();
    ApiHandler._fetchVillageData();
    ApiHandler._fetchStageData();
    ApiHandler._fetchFarmerData();
    ApiHandler._fetchFYRData();
    ApiHandler._fetchForestData();
    ApiHandler._fetchFruitData();
  }

  static Future postApiData(
      {required String url, required Map<dynamic, dynamic> body}) async {
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}
