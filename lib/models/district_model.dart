// To parse this JSON data, do
//
//     final districtModel = districtModelFromJson(jsonString);

import 'dart:convert';

List<DistrictModel?>? districtModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<DistrictModel?>.from(
            json.decode(str)!.map((x) => DistrictModel.fromJson(x)));

String districtModelToJson(List<DistrictModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class DistrictModel {
  DistrictModel({
    required this.districtId,
    required this.districtName,
    required this.status,
  });

  final String? districtId;
  final String? districtName;
  final String? status;

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        districtId: json["district_id"],
        districtName: json["district_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "district_name": districtName,
        "status": status,
      };
}
