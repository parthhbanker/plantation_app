import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantation/api/api.dart';
import 'package:plantation/models/demand_model.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sizer/sizer.dart';

class SyncFormPage extends StatefulWidget {
  const SyncFormPage({super.key});

  @override
  State<SyncFormPage> createState() => _SyncFormPageState();
}

class _SyncFormPageState extends State<SyncFormPage> {
  Future<List<dynamic>> demandList() async {
    return await DbQueries().fetchCustomQuery(
      query:
          "select f.name, fyr.reg_year,  f.aadhar, d.demand_id from demand d join farmer_year_reg fyr on d.reg_id = fyr.reg_id join farmer f on fyr.farmer_id = f.farmer_id",
    );
  }

  @override
  void initState() {
    super.initState();
    dataUpdated.sink.add(1);
  }

  StreamController<int> dataUpdated = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Unsynced Forms",
          style: TextStyle(fontSize: 16),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          width: 100.w,
          height: 100.h,
          margin: const EdgeInsets.all(13),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: dataUpdated.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 0) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else {
                          return FutureBuilder(
                            future: demandList(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done ||
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                if (snapshot.hasData) {
                                  List<dynamic> data = snapshot.data!;
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return customListTile(
                                          aadhar: data[index]['aadhar'],
                                          demandId: data[index]['demand_id'],
                                          farmerName: data[index]['name'],
                                          year: data[index]['reg_year']);
                                    },
                                  );
                                }
                                return const Center(
                                  child: Text("No Data Available"),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            },
                          );
                        }
                      }
                      return const Center(
                        child: Text("No Data Available"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  
                  dataUpdated.sink.add(0);
                  sendData().then((value) {
                    DbQueries().resetDatabase();
                      ApiHandler.fetchApiData();
                  }).then(
                    (value) {
                      
                      dataUpdated.sink.add(1);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 67, 210, 72),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize: const Size(150, 50),
                ),
                child: const Text(
                  "Sync Data",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  customListTile(
      {required String farmerName,
      required String aadhar,
      required String year,
      required int demandId}) {
    return Container(
      width: 100.w,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.blueAccent,
                  size: 26,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$farmerName : $year",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    aadhar,
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                DbQueries.deleteDemand(demandId);
                dataUpdated.sink.add(1);
              },
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendData() async {
    List<dynamic> l = await DbQueries().getDBData(tableName: 'demand');
    for (var element in l) {
      DemandModel obj = DemandModel.fromJson(element);
      ApiHandler.sendDemandData(obj);
    }

    Fluttertoast.showToast(msg: "Data Sync Completed");
  }
}
