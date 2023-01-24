// To parse this JSON data, do
//
//     final fruitTreeModel = fruitTreeModelFromJson(jsonString);

import 'dart:convert';

List<FruitTreeModel?>? fruitTreeModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<FruitTreeModel?>.from(
            json.decode(str)!.map((x) => FruitTreeModel.fromJson(x)));

String fruitTreeModelToJson(List<FruitTreeModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class FruitTreeModel {
  FruitTreeModel({
    required this.id,
    required this.treeName,
    required this.status,
  });

  final String? id;
  final String? treeName;
  final String? status;

  factory FruitTreeModel.fromJson(Map<String, dynamic> json) => FruitTreeModel(
        id: json["id"],
        treeName: json["tree_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tree_name": treeName,
        "status": status,
      };
}
