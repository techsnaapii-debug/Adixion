import 'package:doctor/Core/helper/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeaderHome extends StatelessWidget {
  const CustomHeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          height: orientation == Orientation.portrait ? 90.h : 70.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.homePageHeader),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: orientation == Orientation.portrait ? 30.h : 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi Doctor",
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: "Rubik",
                            fontSize: orientation == Orientation.portrait
                                ? 14.sp
                                : 12.sp,
                          ),
                        ),
                        Text(
                          "Subhash Sharma",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: orientation == Orientation.portrait
                                ? 16.sp
                                : 14.sp,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: orientation == Orientation.portrait ? 22.r : 18.r,
                    backgroundImage: AssetImage(ImageAssets.homeIcon),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
