import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/main_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Get.off(const MainPage(), transition: rTransition());
    });

    return rScaffold(
      rBody: Container(
        color: AppColors().bgWhite,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/seusuro_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                '스마트 수불 로그',
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '스수로',
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
