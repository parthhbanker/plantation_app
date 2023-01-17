import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plantation/Screen/Demand/demand.dart';
import 'package:plantation/utils/dbqueries.dart';

class FarmerPage extends StatefulWidget {
  const FarmerPage({super.key, required this.year, required this.villageId});

  final String year;
  final int villageId;

  @override
  State<FarmerPage> createState() => _FarmerPageState();
}

class _FarmerPageState extends State<FarmerPage> {
  Future<List<dynamic>> farmerList(
      {required int villageId, required String year}) {
    return DbQueries().fetchCustomQuery(
      query:
          'select f.*, fyr.reg_id, fyr.reg_year from farmer f join farmer_year_reg fyr on f.farmer_id = fyr.farmer_id where f.village_id = $villageId and fyr.reg_year = $year',
    );
  }

  StreamController<int> farmerController = StreamController<int>();
  int farmerValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: farmerList(villageId: widget.villageId, year: widget.year),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                List<dynamic> data = snapshot.data!;
                farmerValue = data[0]['reg_id'];

                return CustomDropDown(
                  value: farmerValue,
                  data: data
                      .map(
                        (e) => DropdownMenuItem(
                          value: e['reg_id'],
                          child: Text(e['name']),
                        ),
                      )
                      .toList(),
                  func: (value) {
                    farmerValue = value;
                    farmerController.sink.add(farmerValue);
                  },
                );
              }
            }
          }
          return Center(
            child: Text(
                farmerValue.isNegative ? "" : "No farmer Under this village"),
          );
        },
      ),
    );
  }
}
