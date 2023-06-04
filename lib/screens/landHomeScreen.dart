import 'package:almeno/screens/clickPhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 56.h,
            width: 229.w,
            margin: EdgeInsets.only(top: 492.h, left: 66.w),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r)),
                  backgroundColor: const Color(0xff3E8B3A)),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PhotoScreen()));
              },
              child: Text(
                'Share your meal',
                style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
