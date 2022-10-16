import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';

Widget rScaffold({
  PreferredSizeWidget? rAppBar,
  Widget? rBody,
  Widget? rBottomNavigationBar,
}) {
  var mobileWidth = DataController.to.mobileWidth;

  return Scaffold(
    body: LayoutBuilder(builder: (context, constraints) {
      DataController.to.screenWidth.value = constraints.maxWidth;

      List<Widget> widgetList = [];

      if (rAppBar != null) widgetList.add(rAppBar);
      if (rBody != null) {
        widgetList.add(
          Expanded(child: rBody),
        );
      }
      if (rBottomNavigationBar != null) widgetList.add(rBottomNavigationBar);

      if (!DataController.to.isDesktop()) {
        // Mobile
        return Column(children: widgetList);
      } else {
        // Desktop
        if (constraints.maxWidth > mobileWidth + 480) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 480,
                padding: const EdgeInsets.only(top: 60, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/seusuro_logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: '스',
                            style: TextStyle(
                              color: AppColors().keyRed,
                            ),
                          ),
                          const TextSpan(text: '마트 '),
                          TextSpan(
                            text: '수',
                            style: TextStyle(
                              color: AppColors().keyRed,
                            ),
                          ),
                          const TextSpan(text: '불 '),
                          TextSpan(
                            text: '로',
                            style: TextStyle(
                              color: AppColors().keyRed,
                            ),
                          ),
                          const TextSpan(text: '그'),
                        ],
                      ),
                    ),
                    Text(
                      '스수로',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 343),
                      child: Text(
                        'Made by.',
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Image.asset('assets/automedic_title.png'),
                  ],
                ),
              ),
              Material(
                elevation: 48,
                child: SizedBox(
                  width: mobileWidth,
                  child: Column(children: widgetList),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Material(
              elevation: 48,
              child: SizedBox(
                width: mobileWidth,
                child: Column(children: widgetList),
              ),
            ),
          );
        }
      }
    }),
  );
}
