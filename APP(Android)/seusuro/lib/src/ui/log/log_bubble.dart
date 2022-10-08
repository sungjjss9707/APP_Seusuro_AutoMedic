import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/log_page_controller.dart';

class LogBubble extends StatelessWidget {
  const LogBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _logDate(),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, index) {
            var typeList = ['수입', '불출', '반납', '폐기'];

            return _bubble(receiptPayment: typeList[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 32),
        ),
      ],
    );
  }

  Widget _logDate() {
    return SizedBox(
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 1,
            color: AppColors().textGrey,
          ),
          Container(
            width: 64,
            color: AppColors().bgWhite,
            alignment: Alignment.center,
            child: Text(
              '9월 28일',
              style: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble({required String receiptPayment}) {
    bool leftSide = receiptPayment == '수입';

    Color keyColor;
    String imagePath;

    switch (receiptPayment) {
      case '수입':
        keyColor = AppColors().keyBlue;
        imagePath = 'assets/triangle_left.png';
        break;
      case '불출':
        keyColor = AppColors().keyRed;
        imagePath = 'assets/triangle_right_red.png';
        break;
      case '반납':
        keyColor = AppColors().keyGreen;
        imagePath = 'assets/triangle_right_green.png';
        break;
      case '폐기':
        keyColor = AppColors().keyGrey;
        imagePath = 'assets/triangle_right_grey.png';
        break;
      default:
        keyColor = AppColors().keyBlue;
        imagePath = 'assets/triangle_left.png';
        break;
    }

    return Row(
      mainAxisAlignment:
          leftSide ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leftSide ? _confirmorImage() : Container(),
        SizedBox(
          width: 262,
          child: Stack(
            alignment: leftSide
                ? AlignmentDirectional.topStart
                : AlignmentDirectional.topEnd,
            children: [
              Positioned(
                left: leftSide ? 16 : null,
                right: leftSide ? null : 16,
                child: Text(
                  '일병 유병재',
                  style: TextStyle(
                    color: AppColors().textBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.dialog(
                    _logDetailDialog(
                      receiptPayment: receiptPayment,
                      keyColor: keyColor,
                    ),
                  );
                },
                child: Container(
                  width: 216,
                  margin: EdgeInsets.only(
                    left: leftSide ? 16 : 0,
                    top: 20,
                    right: leftSide ? 0 : 16,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: keyColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '미세먼지 마스크 KF-94 (흰색)',
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1500EA',
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        height: 1,
                        color: AppColors().lineGrey,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      Row(
                        children: [
                          Text(
                            leftSide ? 'From.' : 'To.',
                            style: TextStyle(
                              color: keyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '중위 성준혁',
                            style: TextStyle(
                              color: AppColors().textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: leftSide ? 4 : null,
                top: 14,
                right: leftSide ? null : 4,
                child: Image.asset(imagePath),
              ),
              Positioned(
                left: leftSide ? null : 54,
                top: 15,
                right: leftSide ? 54 : null,
                child: Container(
                  color: AppColors().bgWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    receiptPayment,
                    style: TextStyle(
                      color: keyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: leftSide ? null : 0,
                right: leftSide ? 0 : null,
                bottom: 4,
                child: Text(
                  '11:25',
                  style: TextStyle(
                    color: AppColors().textBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        leftSide ? Container() : _confirmorImage(),
      ],
    );
  }

  Widget _logDetailDialog({
    required String receiptPayment,
    required Color keyColor,
  }) {
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '$receiptPayment 내역',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '10보급대대',
                          style: TextStyle(
                            color: AppColors().textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 36,
                            color: keyColor,
                          ),
                        ),
                        Column(
                          children: [
                            _confirmorImage(),
                            const SizedBox(height: 4),
                            Text(
                              '일병 유병재',
                              style: TextStyle(
                                color: AppColors().textBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: LogPageController.to.detailTitleList.length,
                    itemBuilder: (context, index) {
                      var detailTitleList =
                          LogPageController.to.detailTitleList;
                      var detailContentList =
                          LogPageController.to.detailContentList;

                      return _propertyDetail(
                        title: detailTitleList[index],
                        content: detailContentList[index],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: keyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _propertyDetail({
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            title,
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _confirmorImage() {
    return InkWell(
      onTap: () {
        // 프로필 보기
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors().lineGrey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.person_rounded,
          color: AppColors().lineGrey,
        ),
      ),
    );
  }
}
