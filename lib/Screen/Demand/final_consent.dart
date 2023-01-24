import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plantation/models/demand_model.dart';
import 'package:plantation/utils/components.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:intl/intl.dart';

class FinalConsentPage extends StatefulWidget {
  const FinalConsentPage(
      {super.key,
      required this.farmerRegId,
      required this.forestTree,
      required this.fruitTree,
      required this.farmerSign,
      required this.farmerImage});

  final int farmerRegId;
  final List<Map<String, String>> forestTree;
  final List<Map<String, String>> fruitTree;
  final File farmerSign;
  final File farmerImage;

  @override
  State<FinalConsentPage> createState() => _FinalConsentPageState();
}

class _FinalConsentPageState extends State<FinalConsentPage> {
  File? surveyorSign;
  SignatureController? _signatureController;
  bool permissionGranted = false;

  double totalForestTree = 0;
  double totalFruitTree = 0;
  double totalTree = 0;

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    _signatureController = SignatureController(
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.black,
    );

    dateInput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (Map<String, String> element in widget.forestTree) {
      if (element.values.isNotEmpty) {
        totalForestTree += double.parse(element['qty']!);
      }
    }
    for (Map<String, String> element in widget.fruitTree) {
      if (element.values.isNotEmpty) {
        totalFruitTree += double.parse(element['qty']!);
      }
    }

    totalTree = totalForestTree + totalFruitTree;

    super.initState();
  }

  @override
  void dispose() {
    _signatureController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Consent"),
      ),
      body: Form(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              "Farmer Image",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Image.file(
                            widget.farmerImage,
                            height: 200,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Farmer Sign",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Image.file(
                            widget.farmerSign,
                            height: 8.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomField(
                  title: "Fruit Trees",
                  data: totalFruitTree.toString(),
                ),
                CustomField(
                  title: "Forest Trees",
                  data: totalForestTree.toString(),
                ),
                CustomField(
                  title: "Total Trees",
                  data: totalTree.toString(),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, internalState) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: TextField(
                          controller: dateInput,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Enter Date",
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              internalState(() {
                                dateInput.text = formattedDate;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Surveyor Sign",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Signature(
                      controller: _signatureController!,
                      backgroundColor: const Color.fromARGB(255, 187, 165, 165),
                      dynamicPressureSupported: true,
                      width: 350,
                      height: 200,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _signatureController!.clear();
                          },
                          icon: const Icon(
                            Icons.clear_rounded,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            saveSign().then(
                              (value) => Fluttertoast.showToast(
                                  msg: "Signature Saved"),
                            );
                          },
                          icon: const Icon(
                            Icons.check,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    CommonButton(
                      text: "Save",
                      onPressed: () async {
                        if (_signatureController!.isNotEmpty &&
                            dateInput.text.isNotEmpty) {
                          if (await checkLocationPermission()) {
                            if (widget.fruitTree.contains({})) {
                              widget.fruitTree.removeAt(0);
                            }
                            if (widget.forestTree.contains({})) {
                              widget.forestTree.removeAt(0);
                            }

                            int sid = await getSID();
                            String loc = await getLocation();
                            
                            DemandModel obj = DemandModel(
                              regId: widget.farmerRegId,
                              surveyorId: sid,
                              forestTree: widget.forestTree,
                              fruitTree: widget.fruitTree,
                              farmerImage: widget.farmerImage.path,
                              farmerSign: widget.farmerSign.path,
                              surveyorSign: surveyorSign!.path,
                              demandDate: dateInput.text,
                              location: loc,
                            );
                            DbQueries.addDemandData(obj);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacementNamed(context, '/home');
                            Fluttertoast.showToast(
                              msg: "Data inserted Successfully",
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please allow location permission");
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Fill every fields");
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg: "'Location permissions are permanently denied");
      } else {
        Fluttertoast.showToast(msg: "GPS Location service is granted");
        return true;
      }
    } else {
      Fluttertoast.showToast(msg: "GPS Location permission granted.");
      return true;
    }

    return false;
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String long = position.longitude.toString();
    String lat = position.latitude.toString();

    return "$lat, $long";
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      points: _signatureController!.points,
    );
    //converting the signature to png bytes
    final signature = await exportController.toPngBytes();
    //clean up the memory
    exportController.dispose();
    return signature;
  }

  Future saveSign() async {
    final directory = await getApplicationDocumentsDirectory();
    surveyorSign = await File(
            '${directory.path}/surveyor_sign/${widget.farmerRegId}_surveyor_sign.png')
        .create(recursive: true);

    Uint8List img = (await exportSignature()) as Uint8List;
    surveyorSign!.writeAsBytesSync(img);
  }

  Future<int> getSID() async {
    final prefs = await SharedPreferences.getInstance();

    return int.parse(prefs.getString("surveyor_id")!);
  }
}

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 100.w,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(1.0, 2.0)),
                ]),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
