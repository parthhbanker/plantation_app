import 'dart:convert';

List<BlockModel?>? blockModelFromJson(String str) => json.decode(str) == null
    ? []
    : List<BlockModel?>.from(
        json.decode(str)!.map((x) => BlockModel.fromJson(x)));

String blockModelToJson(List<BlockModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class BlockModel {
  BlockModel({
    required this.blockId,
    required this.blockName,
    required this.districtId,
    required this.status,
  });

  final String? blockId;
  final String? blockName;
  final String? districtId;
  final String? status;

  factory BlockModel.fromJson(Map<String, dynamic> json) => BlockModel(
        blockId: json["block_id"],
        blockName: json["block_name"],
        districtId: json["district_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "block_id": blockId,
        "block_name": blockName,
        "district_id": districtId,
        "status": status,
      };
}
