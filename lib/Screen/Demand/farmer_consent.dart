import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantation/Screen/Demand/final_consent.dart';
import 'package:plantation/utils/components.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

class FarmerConsentPage extends StatefulWidget {
  const FarmerConsentPage(
      {super.key,
      required this.farmerRegId,
      required this.forestTree,
      required this.fruitTree});

  final int farmerRegId;
  final Map<String, double> forestTree;
  final Map<String, double> fruitTree;

  @override
  State<FarmerConsentPage> createState() => _FarmerConsentPageState();
}

class _FarmerConsentPageState extends State<FarmerConsentPage> {
  File? farmerImage;
  File? farmerSign;
  final imagePicker = ImagePicker();
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
        title: const Text("Farmer Consent"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StatefulBuilder(
              builder: (BuildContext context, imageState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Farmer Image",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    farmerImage != null
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 15.sp),
                            width: 100.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.sp),
                              child: Image.file(
                                farmerImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 15.sp),
                            width: 100.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "No Image Taken",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 5.5.h,
                        padding: EdgeInsets.only(bottom: 5.sp),
                        child: ElevatedButton(
                          onPressed: () async {
                            _getStoragePermission().whenComplete(() async {
                              farmerImage = await pickImage();

                              imageState(() {});
                            });
                          },
                          child: Text(
                            "Pick Image",
                            style: TextStyle(fontSize: 12.sp),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              margin: EdgeInsets.all(10.sp),
              child: Column(
                children: [
                  Text(
                    "Farmer Sign",
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
                  CommonButton(
                    text: "Next",
                    onPressed: () {
                      if (_signatureController!.isEmpty) {
                        Fluttertoast.showToast(msg: "Please get farmer sign!");
                      } else if (farmerImage == null) {
                        Fluttertoast.showToast(msg: "Please get farmer image!");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinalConsentPage(
                              farmerRegId: widget.farmerRegId,
                              forestTree: widget.forestTree,
                              fruitTree: widget.fruitTree,
                              farmerSign: farmerSign!,
                              farmerImage: farmerImage!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.camera);

    if (pick != null) {
      final imagePermanent = await saveImage(pick.path);
      return imagePermanent;
    } else {
      return null;
    }
  }

  Future<File> saveImage(String img) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(img);
    final image = await File('${directory.path}/farmer_image/$name')
        .create(recursive: true);

    return File(img).copy(image.path);
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
    farmerSign = await File(
            '${directory.path}/farmer_sign/${widget.farmerRegId}_sign.png')
        .create(recursive: true);

    Uint8List img = (await exportSignature()) as Uint8List;
    farmerSign!.writeAsBytesSync(img);
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }
}
