import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantation/Screen/Demand/farmer_consent.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sizer/sizer.dart';

class TreeFormPage extends StatefulWidget {
  const TreeFormPage({super.key, required this.farmerRegId});

  final int farmerRegId;

  @override
  State<TreeFormPage> createState() => _TreeFormPageState();
}

class _TreeFormPageState extends State<TreeFormPage> {
  Future<List<dynamic>> forestTreeList() async {
    return await DbQueries().getDBData(tableName: 'forest_tree');
  }

  Future<List<dynamic>> fruitTreeList() async {
    return await DbQueries().getDBData(tableName: 'fruit_tree');
  }

  Map<String, double> forestTree = {};
  Map<String, double> fruitTree = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demand Tree'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                // color: const Color.fromARGB(255, 253, 233, 233),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.sp, bottom: 15.sp),
                      child: Text(
                        "Select Forest Tree",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: forestTreeList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            for (var tree in snapshot.data) {
                              return CustomQuantity(
                                tree: tree,
                                list: forestTree,
                              );
                            }
                          } else {
                            return const Text("No data");
                          }
                        }
                        return const Text("No state");
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                // color: const Color.fromARGB(255, 253, 233, 233),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.sp, bottom: 15.sp),
                      child: Text(
                        "Select Fruit Tree",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: fruitTreeList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            for (var tree in snapshot.data) {
                              return CustomQuantity(
                                tree: tree,
                                list: fruitTree,
                              );
                            }
                          } else {
                            return const Text("No data");
                          }
                        }
                        return const Text("No state");
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: ElevatedButton(
                  onPressed: () {
                    if (fruitTree.isEmpty && forestTree.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select alteast 1 forest and fruit tree");
                    } else if (fruitTree.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select alteast 1 fruit tree");
                    } else if (forestTree.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select alteast 1 forest tree");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerConsentPage(
                              forestTree: forestTree,
                              fruitTree: fruitTree,
                              farmerRegId: widget.farmerRegId),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(70.sp, 35.sp),
                    elevation: 8,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomQuantity extends StatelessWidget {
  const CustomQuantity({Key? key, required this.tree, required this.list})
      : super(key: key);

  final dynamic tree;
  final Map<String, double> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tree['tree_name'].toString()),
          CustomizableCounter(
            minCount: 0,
            step: 1,
            borderRadius: 16.sp,
            onCountChange: (c) {
              c == 0
                  ? list.remove(
                      tree['id'].toString(),
                    )
                  : list[tree['id'].toString()] = c;
            },
          ),
        ],
      ),
    );
  }
}
