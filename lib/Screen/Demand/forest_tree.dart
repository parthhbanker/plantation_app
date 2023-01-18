import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantation/Screen/Demand/farmer_consent.dart';
import 'package:plantation/Screen/Demand/fruit_tree.dart';
import 'package:plantation/utils/components.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sizer/sizer.dart';

class ForestTreePage extends StatefulWidget {
  const ForestTreePage({super.key, required this.farmerRegId});

  final int farmerRegId;

  @override
  State<ForestTreePage> createState() => _ForestTreePageState();
}

class _ForestTreePageState extends State<ForestTreePage> {
  Future<List<dynamic>> forestTreeList() async {
    return await DbQueries().getDBData(tableName: 'forest_tree');
  }

  Map<String, double> forestTree = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forest Tree'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.sp),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: forestTreeList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
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
                const Divider(),
                CommonButton(
                  text: "Next",
                  onPressed: () {
                    if (forestTree.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select alteast 1 forest tree");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FruitTreePage(
                            forestTree: forestTree,
                            farmerRegId: widget.farmerRegId,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
