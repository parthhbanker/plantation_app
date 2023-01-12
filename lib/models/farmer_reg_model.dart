// To parse this JSON data, do
//
//     final farmerRegModel = farmerRegModelFromJson(jsonString);

import 'dart:convert';

List<FarmerRegModel?>? farmerRegModelFromJson(String str) => json.decode(str) == null ? [] : List<FarmerRegModel?>.from(json.decode(str)!.map((x) => FarmerRegModel.fromJson(x)));

String farmerRegModelToJson(List<FarmerRegModel?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class FarmerRegModel {
    FarmerRegModel({
        required this.regId,
        required this.farmerId,
        required this.regYear,
        required this.stage,
    });

    final String? regId;
    final String? farmerId;
    final String? regYear;
    final String? stage;

    factory FarmerRegModel.fromJson(Map<String, dynamic> json) => FarmerRegModel(
        regId: json["reg_id"],
        farmerId: json["farmer_id"],
        regYear: json["reg_year"],
        stage: json["stage"],
    );

    Map<String, dynamic> toJson() => {
        "reg_id": regId,
        "farmer_id": farmerId,
        "reg_year": regYear,
        "stage": stage,
    };
}
