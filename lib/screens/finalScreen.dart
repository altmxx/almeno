import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(
          'GOOD JOB',
          style: TextStyle(
            fontSize: 48.sp,
            color: const Color(0xff3E8B3A),
            fontWeight: FontWeight.w400,
          ),
        ),
      )),
    );
  }
}
