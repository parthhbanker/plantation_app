import 'package:flutter/material.dart';
import 'package:plantation/utils/components.dart';
import 'package:sizer/sizer.dart';

class SyncFormPage extends StatefulWidget {
  const SyncFormPage({super.key});

  @override
  State<SyncFormPage> createState() => _SyncFormPageState();
}

class _SyncFormPageState extends State<SyncFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Unsynced Forms",
          style: TextStyle(fontSize: 14.sp),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          width: 100.w,
          height: 100.h,
          margin: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100.w,
                      height: 8.h,
                      margin: EdgeInsets.all(10.sp),
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        borderRadius: BorderRadius.circular(10.sp),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7.0,
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(1.sp, 3.sp),
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
                              Padding(
                                padding: EdgeInsets.only(right: 10.sp),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.blueAccent,
                                  size: 24.sp,
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "List Title",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    "Aadhar",
                                    style: TextStyle(fontSize: 9.sp),
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
                              borderRadius: BorderRadius.circular(5.sp),
                            ),
                            padding: EdgeInsets.all(5.sp),
                            child: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 20.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 67, 210, 72),
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  fixedSize: Size(45.w, 7.h),
                ),
                child: Text(
                  "Sync Data",
                  style: TextStyle(
                    fontSize: 14.sp,
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
}
