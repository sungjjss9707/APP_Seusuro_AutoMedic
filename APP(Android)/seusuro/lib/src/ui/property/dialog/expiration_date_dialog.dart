import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';

class ExpirationDateDialog extends StatelessWidget {
  const ExpirationDateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var isDesktop = DataController.to.isDesktop();

    var mobileWidth = DataController.to.mobileWidth;
    var screenWidth = DataController.to.screenWidth.value;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? mobileWidth : screenWidth,
        margin: EdgeInsets.only(
          left: screenWidth > mobileWidth + 480 ? 480 : 0,
        ),
        padding: const EdgeInsets.all(32),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '유효기간',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '시작일',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      var firstDate = await showDatePicker(
                        context: Get.overlayContext!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022, 3, 21),
                        lastDate: DateTime(2030, 12, 31),
                      );

                      if (firstDate != null) {
                        PropertyPageController.to.firstDate.value = firstDate;
                      }
                    },
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors().lineBlack,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Obx(() => Text(
                            PropertyPageController.to.firstDate.value ==
                                    DateTime(2000, 1, 1)
                                ? '날짜를 선택해주세요'
                                : DateFormat('yyyy년 MM월 dd일').format(
                                    PropertyPageController.to.firstDate.value),
                            style: TextStyle(
                              color: AppColors().textBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '종료일',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      var lastDate = await showDatePicker(
                        context: Get.overlayContext!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022, 3, 21),
                        lastDate: DateTime(2030, 12, 31),
                      );

                      if (lastDate != null) {
                        PropertyPageController.to.lastDate.value = lastDate;
                      }
                    },
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors().lineBlack,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Obx(() => Text(
                            PropertyPageController.to.lastDate.value ==
                                    DateTime(2000, 1, 1)
                                ? '날짜를 선택해주세요'
                                : DateFormat('yyyy년 MM월 dd일').format(
                                    PropertyPageController.to.lastDate.value),
                            style: TextStyle(
                              color: AppColors().textBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
