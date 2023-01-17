import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class FinalConsentPage extends StatefulWidget {
  const FinalConsentPage(
      {super.key,
      required this.farmerRegId,
      required this.forestTree,
      required this.fruitTree,
      required this.farmerSign,
      required this.farmerImage});

  final int farmerRegId;
  final Map<String, double> forestTree;
  final Map<String, double> fruitTree;
  final File farmerSign;
  final File farmerImage;

  @override
  State<FinalConsentPage> createState() => _FinalConsentPageState();
}

class _FinalConsentPageState extends State<FinalConsentPage> {
  File? surveyorSign;
  SignatureController? _signatureController;
  bool permissionGranted = false;

  @override
  void initState() {
    _signatureController = SignatureController(
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.black,
    );
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
      body: Container(
        margin: EdgeInsets.only(top: 5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.sp),
                      child: Text(
                        "Farmer Image",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    Image.file(
                      widget.farmerImage,
                      width: 40.w,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.sp),
                      child: Text(
                        "Farmer Sign",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    Image.file(
                      widget.farmerSign,
                      height: 10.h,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Surveyor Sign",
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                    Signature(
                      controller: _signatureController!,
                      backgroundColor: const Color.fromARGB(255, 187, 165, 165),
                      dynamicPressureSupported: true,
                      width: 70.w,
                      height: 20.h,
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
                            saveSign();
                          },
                          icon: const Icon(
                            Icons.check,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
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
}
