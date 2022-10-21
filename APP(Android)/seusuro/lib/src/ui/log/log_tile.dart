import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/model/log_info.dart';
import 'package:seusuro/src/model/user_info.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LogTile extends StatelessWidget {
  const LogTile({
    Key? key,
    required this.showDate,
    required this.logInfo,
  }) : super(key: key);

  final bool showDate;
  final LogInfo logInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showDate
            ? Column(
                children: [
                  _logDate(logInfo: logInfo),
                  const SizedBox(height: 16),
                ],
              )
            : Container(),
        _tileForm(logInfo: logInfo),
      ],
    );
  }

  Widget _logDate({required LogInfo logInfo}) {
    String createdAt = logInfo.createdAt;

    var month = createdAt.substring(5, 7);
    var day = createdAt.substring(8, 10);

    return SizedBox(
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 1,
            color: AppColors().textLightGrey,
          ),
          Container(
            width: 64,
            color: AppColors().bgWhite,
            alignment: Alignment.center,
            child: Text(
              '$month월 $day일',
              style: TextStyle(
                color: AppColors().textLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tileForm({required LogInfo logInfo}) {
    bool leftSide = logInfo.receiptPayment == '수입';

    Color keyColor;

    switch (logInfo.receiptPayment) {
      case '수입':
        keyColor = AppColors().keyBlue;
        break;
      case '불출':
        keyColor = AppColors().keyRed;
        break;
      case '반납':
        keyColor = AppColors().keyGreen;
        break;
      case '폐기':
        keyColor = AppColors().keyGrey;
        break;
      default:
        keyColor = AppColors().keyBlue;
        break;
    }

    var logDetailWidgets = [
      const SizedBox(width: 8),
      Text(
        logInfo.target,
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 36,
          color: keyColor,
        ),
      ),
      Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: logInfo.items.length,
          itemBuilder: (context, index) {
            var itemInfo = logInfo.items[index];

            return _itemTile(itemInfo);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    ];

    var confirmorWidgets = [
      _confirmorImage(confirmor: logInfo.confirmor),
      const SizedBox(width: 4),
      Center(
        child: Text(
          '${logInfo.confirmor.rank} ${logInfo.confirmor.name}',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      const Spacer(),
      Text(
        logInfo.createdAt.substring(11, 16),
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(width: 4),
    ];

    if (!leftSide) {
      logDetailWidgets = List.from(logDetailWidgets.reversed);
      confirmorWidgets = List.from(confirmorWidgets.reversed);
    }

    return Column(
      children: [
        Stack(
          alignment: leftSide
              ? AlignmentDirectional.topStart
              : AlignmentDirectional.topEnd,
          children: [
            InkWell(
              onTap: () {
                Get.dialog(
                  _logDetailDialog(
                    logInfo: logInfo,
                    keyColor: keyColor,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5.5),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: keyColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: logDetailWidgets),
              ),
            ),
            Positioned(
              left: leftSide ? null : 24,
              right: leftSide ? 24 : null,
              child: Container(
                color: AppColors().bgWhite,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  logInfo.receiptPayment,
                  style: TextStyle(
                    color: keyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: confirmorWidgets,
          ),
        ),
      ],
    );
  }

  Widget _itemTile(ItemInfo itemInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          itemInfo.name,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${itemInfo.amount.toString()} ${itemInfo.unit}',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _logDetailDialog({
    required LogInfo logInfo,
    required Color keyColor,
  }) {
    var isDesktop = DataController.to.isDesktop();

    var mobileWidth = DataController.to.mobileWidth;
    var screenWidth = DataController.to.screenWidth.value;

    var itemList = logInfo.items;
    var pageController = PageController();

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
                    '${logInfo.receiptPayment} 내역',
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
                        logInfo.receiptPayment == '수입'
                            ? Text(
                                logInfo.target,
                                style: TextStyle(
                                  color: AppColors().textBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Column(
                                children: [
                                  _confirmorImage(confirmor: logInfo.confirmor),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${logInfo.confirmor.rank} ${logInfo.confirmor.name}',
                                    style: TextStyle(
                                      color: AppColors().textBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 36,
                            color: keyColor,
                          ),
                        ),
                        logInfo.receiptPayment == '수입'
                            ? Column(
                                children: [
                                  _confirmorImage(confirmor: logInfo.confirmor),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${logInfo.confirmor.rank} ${logInfo.confirmor.name}',
                                    style: TextStyle(
                                      color: AppColors().textBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                logInfo.target,
                                style: TextStyle(
                                  color: AppColors().textBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    height: 180,
                    alignment: Alignment.center,
                    child: PageView(
                      controller: pageController,
                      children: List.generate(
                        itemList.length,
                        (index) => _itemDetail(itemList[index], logInfo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: itemList.length,
                    effect: WormEffect(
                      radius: 4,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: AppColors().lineGrey,
                      activeDotColor: keyColor,
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

  Widget _itemDetail(ItemInfo itemInfo, LogInfo logInfo) {
    return Column(
      children: [
        _detailTile(title: '품명', content: itemInfo.name),
        const SizedBox(height: 8),
        _detailTile(title: '분류', content: itemInfo.category),
        const SizedBox(height: 8),
        _detailTile(title: 'NIIN', content: itemInfo.niin),
        const SizedBox(height: 8),
        _detailTile(
          title: '수량',
          content: '${itemInfo.amount.toString()} ${itemInfo.unit}',
        ),
        const SizedBox(height: 8),
        _detailTile(
          title: '유효기간',
          content:
              '${itemInfo.expirationDate.replaceRange(4, 5, '년 ').replaceRange(8, 9, '월 ')}일',
        ),
        const SizedBox(height: 8),
        _detailTile(title: '보관장소', content: itemInfo.storagePlace),
        const SizedBox(height: 8),
        _detailTile(
          title: '수입시각',
          content: logInfo.createdAt
              .substring(0, 16)
              .replaceRange(4, 5, '년 ')
              .replaceRange(8, 9, '월 ')
              .replaceRange(12, 13, '일 '),
        ),
      ],
    );
  }

  Widget _confirmorImage({required UserInfo confirmor}) {
    return InkWell(
      onTap: () {
        Get.dialog(_confirmorDialog(confirmor: confirmor));
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
        child: confirmor.pictureName.isEmpty
            ? Icon(
                Icons.person_rounded,
                color: AppColors().keyGrey,
              )
            : ImageNetwork(
                width: 32,
                height: 32,
                image: confirmor.pictureName,
                onTap: () {
                  Get.dialog(_confirmorDialog(confirmor: confirmor));
                },
                onLoading: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: AppColors().keyGrey,
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
      ),
    );
  }

  Widget _confirmorDialog({required UserInfo confirmor}) {
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
                    '확인자 정보',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppColors().lineGrey,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: confirmor.pictureName.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            color: AppColors().keyGrey,
                          )
                        : ImageNetwork(
                            width: 100,
                            height: 100,
                            image: confirmor.pictureName,
                            onLoading: CircularProgressIndicator(
                              color: AppColors().keyGrey,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                  ),
                  const SizedBox(height: 32),
                  _detailTile(title: '이름', content: confirmor.name),
                  const SizedBox(height: 8),
                  _detailTile(title: '계급', content: confirmor.rank),
                  const SizedBox(height: 8),
                  _detailTile(title: '군번', content: confirmor.serviceNumber),
                  const SizedBox(height: 8),
                  _detailTile(title: '소속부대', content: confirmor.militaryUnit),
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

Widget _detailTile({
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
