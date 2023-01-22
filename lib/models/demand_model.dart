import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<DemandModel?>? districtModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<DemandModel?>.from(
            json.decode(str)!.map(
                  (x) => DemandModel.fromJson(x),
                ),
          );

String districtModelToJson(List<DemandModel?>? data) => json.encode(
      data == null
          ? []
          : List<dynamic>.from(
              data.map(
                (x) => x!.toJson(),
              ),
            ),
    );

class DemandModel {
  DemandModel(
      {this.demandId,
      required this.regId,
      required this.surveyorId,
      required this.forestTree,
      required this.fruitTree,
      required this.farmerImage,
      required this.farmerSign,
      required this.surveyorSign,
      required this.demandDate});

  final int? demandId;
  final int regId;
  final int surveyorId;
  final List<Map<String, String>> forestTree;
  final List<Map<String, String>> fruitTree;
  final String farmerImage;
  final String farmerSign;
  final String surveyorSign;
  final String demandDate;

  factory DemandModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> f = jsonDecode(json['forest_tree']);
    List<Map<String, String>> forest = [];
    for (var element in f) {
      if (!element.values.isEmpty) {
        forest.add({"id": element['id'], "qty": element['qty']});
      }
    }

    f = jsonDecode(json['fruit_tree']);
    List<Map<String, String>> fruit = [];
    for (var element in f) {
      if (!element.values.isEmpty) {
        fruit.add({"id": element['id'], "qty": element['qty']});
      }
    }

    return DemandModel(
      demandId: json['demand_id'],
      farmerImage: json['farmer_img'],
      farmerSign: json['farmer_sign'],
      forestTree: forest,
      fruitTree: fruit,
      regId: json['reg_id'],
      surveyorId: json['surveyor_id'],
      surveyorSign: json['surveyor_sign'],
      demandDate: json['demand_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'farmer_img': farmerImage,
        'farmer_sign': farmerSign,
        'forest_tree': jsonEncode(forestTree),
        'fruit_tree': jsonEncode(fruitTree),
        'reg_id': regId,
        'surveyor_id': surveyorId,
        'surveyor_sign': surveyorSign,
        'demand_date': demandDate,
      };
}
