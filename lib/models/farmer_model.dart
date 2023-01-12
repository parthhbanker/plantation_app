import 'dart:convert';

List<FarmerModel?>? farmerModelFromJson(String str) => json.decode(str) == null
    ? []
    : List<FarmerModel?>.from(
        json.decode(str)!.map((x) => FarmerModel.fromJson(x)));

String farmerModelToJson(List<FarmerModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class FarmerModel {
  FarmerModel({
    required this.farmerId,
    required this.name,
    required this.phone,
    required this.aadhar,
    required this.sex,
    required this.villageId,
    required this.status,
  });

  final String? farmerId;
  final String? name;
  final String? phone;
  final String? aadhar;
  final String? sex;
  final String? villageId;
  final String? status;

  factory FarmerModel.fromJson(Map<String, dynamic> json) => FarmerModel(
        farmerId: json["farmer_id"],
        name: json["name"],
        phone: json["phone"],
        aadhar: json["aadhar"],
        sex: json["sex"],
        villageId: json["village_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "farmer_id": farmerId,
        "name": name,
        "phone": phone,
        "aadhar": aadhar,
        "sex": sex,
        "village_id": villageId,
        "status": status,
      };
}
