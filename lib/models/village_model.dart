// To parse this JSON data, do
//
//     final villageModel = villageModelFromJson(jsonString);

import 'dart:convert';

List<VillageModel?>? villageModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<VillageModel?>.from(
            json.decode(str)!.map((x) => VillageModel.fromJson(x)));

String villageModelToJson(List<VillageModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class VillageModel {
  VillageModel({
    required this.villageId,
    required this.villageName,
    required this.blockId,
    this.status,
  });

  final String villageId;
  final String villageName;
  final String blockId;
  final String? status;

  factory VillageModel.fromJson(Map<String, dynamic> json) => VillageModel(
        villageId: json["village_id"],
        villageName: json["village_name"],
        blockId: json["block_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "village_id": villageId,
        "village_name": villageName,
        "block_id": blockId,
        "status": status,
      };
}
