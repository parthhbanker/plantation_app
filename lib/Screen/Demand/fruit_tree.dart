import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantation/Screen/Demand/farmer_consent.dart';
import 'package:plantation/utils/components.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:sizer/sizer.dart';

class FruitTreePage extends StatefulWidget {
  const FruitTreePage(
      {super.key, required this.farmerRegId, required this.forestTree});

  final int farmerRegId;
  final List<Map<String, String>> forestTree;

  @override
  State<FruitTreePage> createState() => _FruitTreePageState();
}

class _FruitTreePageState extends State<FruitTreePage> {
  Future<List<dynamic>> fruitTreeList() async {
    return await DbQueries().getDBData(tableName: 'fruit_tree');
  }

  List<Map<String, String>> fruitTree = [{}];
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: fruitTreeList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<dynamic> data = snapshot.data;
                        return SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return CustomQuantity(
                                tree: data[index],
                                list: fruitTree,
                              );
                            },
                          ),
                        );
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
                    if (fruitTree.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select alteast 1 fruit tree");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerConsentPage(
                              forestTree: widget.forestTree,
                              fruitTree: fruitTree,
                              farmerRegId: widget.farmerRegId),
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
