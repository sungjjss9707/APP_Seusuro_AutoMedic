import 'package:flutter/material.dart';
import 'package:seusuro/src/controller/data_controller.dart';

Widget rBottomSheet({
  double? height,
  Color? color,
  EdgeInsetsGeometry? padding,
  Widget? child,
}) {
  var isDesktop = DataController.to.isDesktop();

  var mobileWidth = DataController.to.mobileWidth;
  var screenWidth = DataController.to.screenWidth.value;

  return Padding(
    padding: EdgeInsets.only(
      left: !isDesktop
          ? 0
          : screenWidth > mobileWidth + 480
              ? (screenWidth - 840) / 2 + 480
              : screenWidth > mobileWidth
                  ? (screenWidth - mobileWidth) / 2
                  : 0,
      right: !isDesktop
          ? 0
          : screenWidth > mobileWidth + 480
              ? (screenWidth - 840) / 2
              : screenWidth > mobileWidth
                  ? (screenWidth - mobileWidth) / 2
                  : 0,
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        height: height,
        color: color,
        padding: padding,
        child: child,
      ),
    ),
  );
}
