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
                      var firstDate = await _showDatePicker(Get.overlayContext!);

                      if (firstDate != null) {
                        PropertyPageController.to.startDate.value = firstDate;
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
                            PropertyPageController.to.startDate.value ==
                                    DateTime(2000, 1, 1)
                                ? '날짜를 선택해주세요'
                                : DateFormat('yyyy년 MM월 dd일').format(
                                    PropertyPageController.to.startDate.value),
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
                      var lastDate = await _showDatePicker(Get.overlayContext!);

                      if (lastDate != null) {
                        PropertyPageController.to.endDate.value = lastDate;
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
                            PropertyPageController.to.endDate.value ==
                                    DateTime(2000, 1, 1)
                                ? '날짜를 선택해주세요'
                                : DateFormat('yyyy년 MM월 dd일').format(
                                    PropertyPageController.to.endDate.value),
                            style: TextStyle(
                              color: AppColors().textBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            PropertyPageController.to.startDate.value =
                                DateTime(2000, 1, 1);
                            PropertyPageController.to.endDate.value =
                                DateTime(2000, 1, 1);
                          },
                          child: Center(
                            child: Text(
                              '초기화',
                              style: TextStyle(
                                color: AppColors().textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (await PropertyPageController.to
                                .getProperties()) {
                              Get.back();
                            }
                          },
                          child: Center(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                color: AppColors().textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors().keyBlue,
              onPrimary: AppColors().textWhite,
              onSurface: AppColors().textBlack,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
