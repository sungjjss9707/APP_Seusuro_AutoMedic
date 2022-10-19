import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/log_page_controller.dart';
import 'package:seusuro/src/model/log_info.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/log/log_bubble.dart';
import 'package:seusuro/src/ui/log/write_log_page.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LogPageController());

    return Column(
      children: [
        _appBar(),
        Expanded(
          child: Container(
            color: AppColors().bgWhite,
            child: Stack(
              children: [
                Obx(() => ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: LogPageController.to.logList.length,
                      itemBuilder: (context, index) {
                        LogInfo logInfo = LogPageController.to.logList[index];
                        String createdDate = logInfo.createdAt.substring(0, 10);

                        if (!LogPageController.to.dateList
                            .contains(createdDate)) {
                          LogPageController.to.dateList.add(createdDate);
                          LogPageController.to.showDateList.add(logInfo.id);
                        }

                        bool showDate = LogPageController.to.showDateList
                            .contains(logInfo.id);

                        return LogBubble(showDate: showDate, logInfo: logInfo);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 32),
                    )),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: _selectLogType(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '수불 로그',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(_logFilterDialog());
          },
          icon: Icon(
            Icons.filter_alt_rounded,
            color: AppColors().bgBlack,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _logFilterDialog() {
    var isDesktop = DataController.to.isDesktop();

    var mobileWidth = DataController.to.mobileWidth;
    var screenWidth = DataController.to.screenWidth.value;

    var colorMap = {
      '수입': AppColors().keyBlue,
      '불출': AppColors().keyRed,
      '반납': AppColors().keyGreen,
      '폐기': AppColors().keyGrey,
    };

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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '로그 필터',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '로그 종류',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 36,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      String receiptPayment = colorMap.keys.toList()[index];

                      return InkWell(
                        onTap: () {
                          if (!LogPageController.to.logTypeList
                              .contains(receiptPayment)) {
                            LogPageController.to.logTypeList
                                .add(receiptPayment);
                          } else {
                            LogPageController.to.logTypeList
                                .remove(receiptPayment);
                          }
                        },
                        child: Obx(() => Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: LogPageController.to.logTypeList
                                        .contains(receiptPayment)
                                    ? colorMap[receiptPayment]
                                    : AppColors().bgWhite,
                                border: Border.all(
                                  width: 1,
                                  color: colorMap[receiptPayment]!,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                receiptPayment,
                                style: TextStyle(
                                  color: LogPageController.to.logTypeList
                                          .contains(receiptPayment)
                                      ? AppColors().textWhite
                                      : colorMap[receiptPayment],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '날짜 선택',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      var filterDate = await showDatePicker(
                        context: Get.overlayContext!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022, 3, 21),
                        lastDate: DateTime(2030, 12, 31),
                      );

                      if (filterDate != null) {
                        LogPageController.to.filterDate.value = filterDate;
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
                            LogPageController.to.filterDate.value ==
                                    DateTime(2000, 1, 1)
                                ? '날짜를 선택해주세요'
                                : DateFormat('yyyy년 MM월 dd일').format(
                                    LogPageController.to.filterDate.value),
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

  Widget _selectLogType() {
    return FloatingActionButton(
      onPressed: () {
        Get.dialog(_logTypeDialog());
      },
      backgroundColor: AppColors().bgBlack,
      child: const Icon(Icons.edit_rounded),
    );
  }

  Widget _logTypeDialog() {
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
          bottom: 65,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            _writeLogButton(receiptPayment: '수입'),
            _writeLogButton(receiptPayment: '불출'),
            _writeLogButton(receiptPayment: '반납'),
            _writeLogButton(receiptPayment: '폐기'),
            FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              backgroundColor: AppColors().bgBlack,
              child: const Icon(Icons.clear_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _writeLogButton({required String receiptPayment}) {
    Color keyColor;
    IconData? icon;

    switch (receiptPayment) {
      case '수입':
        keyColor = AppColors().keyBlue;
        icon = Icons.file_download_rounded;
        break;
      case '불출':
        keyColor = AppColors().keyRed;
        icon = Icons.file_upload_rounded;
        break;
      case '반납':
        keyColor = AppColors().keyGreen;
        icon = Icons.refresh_rounded;
        break;
      case '폐기':
        keyColor = AppColors().keyGrey;
        icon = Icons.delete_outline_rounded;
        break;
      default:
        keyColor = AppColors().keyBlue;
        icon = Icons.file_download_rounded;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FloatingActionButton.extended(
        onPressed: () {
          Get.back();
          Get.to(
            () => WriteLogPage(
              receiptPayment: receiptPayment,
              keyColor: keyColor,
            ),
            transition: rTransition(),
          );
        },
        backgroundColor: keyColor,
        icon: Icon(icon),
        label: Text(
          receiptPayment,
          style: TextStyle(
            color: AppColors().textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
