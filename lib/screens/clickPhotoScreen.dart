import 'dart:developer';
import 'dart:io';

import 'package:almeno/main.dart';
import 'package:almeno/screens/finalScreen.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  FirebaseStorage storage = FirebaseStorage.instance;
  bool _isUploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.medium);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        } else {
          setState(() {});
        }
      });
    } else {
      log('No cameras found');
    }
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      const Uuid().v1(),
      'Food Shared',
      channelDescription: 'Thank you for sharing food with me!',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, 'Image Upload',
        'Image has been uploaded successfully!', platformChannelSpecifics,
        payload: 'notification_payload');
  }

  Future<void> uploadImage(XFile imageXFile) async {
    _isUploading = true;
    File imageFile = File(imageXFile.path);
    String fileName = path.basename(imageFile.path);
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    try {
      await uploadTask;
      print('Upload complete');
      String downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');
      _isUploading = false;
      setState(() {});
      showNotification();
    } catch (e) {
      print('Upload Failed: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Container(
              width: 45.w,
              height: 45.h,
              margin: EdgeInsets.only(left: 24.w),
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: const Color(0xff3E8B3A),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            Container(
              width: 250.w,
              height: 130.h,
              margin: EdgeInsets.only(left: 100.w),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/baby S.png'))),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r),
                    ),
                    color: const Color(0xffF4F4F4)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 53.4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 28.16.w,
                            height: 149.84.h,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/Fork.png'))),
                          ),
                          SizedBox(width: 14.84.w),
                          Stack(
                            children: [
                              // Transparent middle box
                              image == null
                                  ? Container(
                                      width: 250.94.w,
                                      height: 207.66.h,
                                      color: Colors.transparent,
                                      child: ClipOval(
                                        child: Container(
                                          height: 150.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(150.r)),
                                          child: controller == null
                                              ? const Center(
                                                  child: Text("Loading camera"))
                                              : !controller!.value.isInitialized
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : CameraPreview(controller!),
                                        ),
                                      ),
                                      // Add any other properties or widgets as needed
                                    )
                                  : Container(
                                      width: 250.94.w,
                                      height: 207.66.h,
                                      color: Colors.transparent,
                                      child: ClipOval(
                                        child: Container(
                                          height: 150.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(150.r)),
                                          child: Image.file(
                                            File(image!.path),
                                            height: 300.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              // Top left corner line
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 5.w,
                                  height: 31.46.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 31.46.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              // Top right corner line
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 5.w,
                                  height: 31.46.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 31.46.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              // Bottom left corner line
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  width: 5.w,
                                  height: 31.46.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  width: 31.46.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              // Bottom right corner line
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 5.w,
                                  height: 31.46.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 31.46.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: const Color(0xff5EA451),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 38.64.w,
                            height: 153.h,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/Spoon.png'))),
                          ),
                        ],
                      ),
                      SizedBox(height: 19.34.h),
                      image == null
                          ? Container(
                              width: 224.w,
                              height: 37.h,
                              alignment: Alignment.center,
                              child: Text(
                                'Click your meal',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          : Container(
                              width: 224.w,
                              height: 37.h,
                              alignment: Alignment.center,
                              child: Text(
                                'Will you eat this?',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                      image == null
                          ? SizedBox(
                              width: 64.w,
                              height: 64.h,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  backgroundColor: const Color(0xff3E8B3A),
                                  onPressed: () async {
                                    try {
                                      if (controller != null) {
                                        if (controller!.value.isInitialized) {
                                          image =
                                              await controller!.takePicture();
                                          setState(() {});
                                        }
                                      }
                                    } catch (e) {
                                      log('Error occured $e');
                                    }
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 40.sp,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 64.w,
                              height: 64.h,
                              child: FittedBox(
                                child: FloatingActionButton(
                                  backgroundColor: const Color(0xff3E8B3A),
                                  onPressed: () {
                                    uploadImage(image!).then((_) {
                                      image = null;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const FinalScreen())));
                                    });
                                  },
                                  child: !_isUploading
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 40.sp,
                                        )
                                      : const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
