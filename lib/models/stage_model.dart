// To parse this JSON data, do
//
//     final stageModel = stageModelFromJson(jsonString);

import 'dart:convert';

List<StageModel?>? stageModelFromJson(String str) => json.decode(str) == null ? [] : List<StageModel?>.from(json.decode(str)!.map((x) => StageModel.fromJson(x)));

String stageModelToJson(List<StageModel?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data
.map((x) => x!.toJson())));

class StageModel {
    StageModel({
        required this.stageId,
        required this.stage,
    });

    final String? stageId;
    final String? stage;

    factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
        stageId: json["stage_id"],
        stage: json["stage"],
    );

    Map<String, dynamic> toJson() => {
        "stage_id": stageId,
        "stage": stage,
    };
}
