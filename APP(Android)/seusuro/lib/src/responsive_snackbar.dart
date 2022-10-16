import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/controller/data_controller.dart';

void rSnackbar({
  required String? title,
  required String? message,
}) {
  var isDesktop = DataController.to.isDesktop();

  var mobileWidth = DataController.to.mobileWidth;
  var screenWidth = DataController.to.screenWidth.value;

  Get.snackbar(
    title!,
    message!,
    maxWidth: 328,
    duration: const Duration(seconds: 2),
    snackPosition: SnackPosition.TOP,
    margin: EdgeInsets.only(
      left: !isDesktop
          ? 16
          : screenWidth > mobileWidth + 480
              ? 480
              : screenWidth > mobileWidth
                  ? 0
                  : 16,
      top: 16,
      right: !isDesktop
          ? 16
          : screenWidth > mobileWidth
              ? 0
              : 16,
    ),
  );
}
