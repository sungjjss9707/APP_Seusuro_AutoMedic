import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/log_page_controller.dart';
import 'package:seusuro/src/ui/log/log_bubble.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LogPageController());

    return Container(
      color: AppColors().bgWhite,
      child: Stack(
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) => const LogBubble(),
              separatorBuilder: (context, index) => const SizedBox(height: 32),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _selectLogType(),
          ),
        ],
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
          // 로그 작성하기
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
