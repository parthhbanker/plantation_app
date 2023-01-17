import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plantation/Screen/Demand/tree_form.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sizer/sizer.dart';

class DemandPage extends StatefulWidget {
  const DemandPage({super.key});

  @override
  State<DemandPage> createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {
  StreamController<int> districtController = StreamController<int>();
  StreamController<int> blockController = StreamController<int>();
  StreamController<int> villageController = StreamController<int>();
  StreamController<int> farmerController = StreamController<int>();

  late int districtValue;
  late int blockValue;
  int villageValue = -1;
  late String yearValue;
  int farmerValue = -1;

  @override
  void dispose() {
    districtController.close();
    blockController.close();
    villageController.close();
    farmerController.close();
    super.dispose();
  }

  Future<List<dynamic>> yearList() async {
    return await DbQueries().fetchCustomQuery(
        query: "SELECT DISTINCT(reg_year) FROM farmer_year_reg");
  }

  Future<List<dynamic>> districtList() async {
    return await DbQueries().getDBData(tableName: 'district');
  }

  Future<List<dynamic>> blockList({required int districtId}) async {
    return await DbQueries().fetchCustomQuery(
        query: 'select * from block where district_id = $districtId');
  }

  Future<List<dynamic>> villageList({required int blockId}) async {
    return await DbQueries().fetchCustomQuery(
        query: 'select * from village where block_id = $blockId');
  }

  Future<List<dynamic>> farmerList(
      {required int villageId, required String year}) {
    return DbQueries().fetchCustomQuery(
      query:
          'select f.*, fyr.reg_id, fyr.reg_year from farmer f join farmer_year_reg fyr on f.farmer_id = fyr.farmer_id where f.village_id = $villageId and fyr.reg_year = $year and fyr.stage = 1',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demand Tree'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              yearListWidget(),
              districtListWidget(),
              blockListWidget(),
              villageListWidget(),
              farmerListWidget(),
              nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<Object> nextButton() {
    return StreamBuilder<Object>(
        stream: farmerController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              int val = int.parse(snapshot.data.toString());
              return Padding(
                padding: EdgeInsets.all(8.sp),
                child: ElevatedButton(
                  onPressed: val.isNegative
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TreeFormPage(
                                farmerRegId: farmerValue,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(70.sp, 35.sp),
                    elevation: 8,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            }
          }
          return const Text("");
        });
  }

  StreamBuilder<int> blockListWidget() {
    return StreamBuilder<int>(
      stream: districtController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder<List<dynamic>>(
              future: blockList(districtId: snapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.data!;
                    blockValue = data[0]['block_id'];

                    return CustomDropDown(
                      value: blockValue,
                      data: data
                          .map(
                            (e) => DropdownMenuItem(
                              value: e['block_id'],
                              child: Text(e['block_name']),
                            ),
                          )
                          .toList(),
                      func: (var value) {
                        blockValue = int.parse(
                          value.toString(),
                        );
                        villageValue = -1;
                        villageController.sink.add(villageValue);
                        blockController.sink.add(blockValue);
                      },
                    );
                  }
                }
                return const Center(
                  child: Text(""),
                );
              },
            );
          }
        }
        return const Center(
          child: Text(""),
        );
      },
    );
  }

  StreamBuilder<int> villageListWidget() {
    return StreamBuilder<int>(
      stream: blockController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder<List<dynamic>>(
              future: villageList(blockId: snapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      List<dynamic> data = snapshot.data!;
                      villageValue = data[0]['village_id'];

                      return CustomDropDown(
                        value: villageValue,
                        data: data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e['village_id'],
                                child: Text(e['village_name']),
                              ),
                            )
                            .toList(),
                        func: (value) {
                          villageValue = value;
                          farmerValue = -1;
                          farmerController.sink.add(farmerValue);
                          villageController.sink.add(villageValue);
                        },
                      );
                    }
                  }
                }
                return Center(
                  child: Text(
                    (!villageValue.isNegative)
                        ? ""
                        : "No village Under this block",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                );
              },
            );
          }
        }
        return const Center(
          child: Text(""),
        );
      },
    );
  }

  StreamBuilder<int> farmerListWidget() {
    return StreamBuilder<int>(
      stream: villageController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder<List<dynamic>>(
              future: farmerList(villageId: snapshot.data!, year: yearValue),
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
                    (farmerValue.isNegative && !villageValue.isNegative)
                        ? ""
                        : "No farmer Under this village",
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                );
              },
            );
          }
        }
        return const Center(
          child: Text(""),
        );
      },
    );
  }

  FutureBuilder<List<dynamic>> districtListWidget() {
    return FutureBuilder<List<dynamic>>(
      future: districtList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data;
            districtValue = data[0]['district_id'];
            return CustomDropDown(
                value: districtValue,
                data: data
                    .map(
                      (e) => DropdownMenuItem(
                        value: e['district_id'],
                        child: Text(e['district_name']),
                      ),
                    )
                    .toList(),
                func: (var value) {
                  districtValue = int.parse(
                    value.toString(),
                  );
                  districtController.sink.add(districtValue);
                });
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text(
            !(districtValue.isNegative) ? "" : "No district available",
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<List<dynamic>> yearListWidget() {
    return FutureBuilder<List<dynamic>>(
      future: yearList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> data = snapshot.data;
            yearValue = data[0]['reg_year'];
            return CustomDropDown(
                // value: districtValue,
                data: data
                    .map(
                      (e) => DropdownMenuItem(
                        // value: e['reg_year'],
                        child: Text(e['reg_year']),
                      ),
                    )
                    .toList(),
                func: (var value) {
                  yearValue = value.toString();
                });
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text(
            (yearValue.isNotEmpty) ? "" : "No farmer registered",
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        );
      },
    );
  }
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    this.value,
    required this.data,
    required this.func,
  }) : super(key: key);

  final int? value;
  final List<DropdownMenuItem> data;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 12.sp),
      child: DropdownButtonFormField(
        value: value,
        items: data,
        decoration: InputDecoration(
          focusColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black38,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(15.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(15.sp),
          ),
          filled: true,
          fillColor: Colors.grey[250],
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: BorderSide(
              color: Colors.red.shade600,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12.sp),

        // isExpanded: true,
        onChanged: (value) {
          func(value);
        },
      ),
    );
  }
}
