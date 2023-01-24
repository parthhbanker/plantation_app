// To parse this JSON data, do
//
//     final forestTreeModel = forestTreeModelFromJson(jsonString);

import 'dart:convert';

List<ForestTreeModel?>? forestTreeModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<ForestTreeModel?>.from(
            json.decode(str)!.map((x) => ForestTreeModel.fromJson(x)));

String forestTreeModelToJson(List<ForestTreeModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class ForestTreeModel {
  ForestTreeModel({
    required this.id,
    required this.treeName,
    required this.status,
  });

  final String? id;
  final String? treeName;
  final String? status;

  factory ForestTreeModel.fromJson(Map<String, dynamic> json) =>
      ForestTreeModel(
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
