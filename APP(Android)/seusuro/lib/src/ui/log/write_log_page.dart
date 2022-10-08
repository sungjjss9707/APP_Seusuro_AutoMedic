import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/bottom_button.dart';
import 'package:seusuro/src/controller/ui/write_log_page_controller.dart';
import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/log/write_log_dialog.dart';

class WriteLogPage extends StatelessWidget {
  const WriteLogPage({
    required this.receiptPayment,
    required this.keyColor,
    super.key,
  });

  final String receiptPayment;
  final Color keyColor;

  @override
  Widget build(BuildContext context) {
    Get.put(WriteLogPageController());

    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  _logTarget(),
                  const SizedBox(height: 32),
                  _logDetail(),
                  const SizedBox(height: 16),
                  _addLogButton(),
                ],
              ),
            ),
            BottomButton(
              content: '작성 완료',
              onTap: () {
                // 로그 작성 완료
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '로그 기록하기',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors().bgBlack,
        ),
      ),
    );
  }

  Widget _logTarget() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              receiptPayment,
              style: TextStyle(
                color: keyColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '대상',
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: WriteLogPageController.to.targetEditingController,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors().bgBlack,
          decoration: InputDecoration(
            hintText: '대상자의 이름 혹은 부대명을 작성해주세요',
            hintStyle: TextStyle(
              color: AppColors().textGrey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: AppColors().lineBlack,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: AppColors().lineBlack,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _logDetail() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              receiptPayment,
              style: TextStyle(
                color: keyColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '내역',
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.separated(
              shrinkWrap: true,
              itemCount: WriteLogPageController.to.itemList.length,
              itemBuilder: (context, index) {
                var itemInfo = WriteLogPageController.to.itemList[index];

                return _propertyTile(itemInfo: itemInfo);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            )),
      ],
    );
  }

  Widget _propertyTile({required ItemInfo itemInfo}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors().lineBlack.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          var detailTitleList = WriteLogPageController.to.detailTitleList;

          var detailContentList = [];

          detailContentList.add(itemInfo.name);
          detailContentList.add(itemInfo.category);
          detailContentList
              .add('${itemInfo.amount.toString()} ${itemInfo.unit}');
          detailContentList
              .add(DateFormat('yyyy년 MM월 dd일').format(itemInfo.expirationDate));
          detailContentList.add(itemInfo.storagePlace);

          return _propertyDetail(
            title: detailTitleList[index],
            content: detailContentList[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
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
          width: 88,
          child: Text(
            title,
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _addLogButton() {
    return InkWell(
      onTap: () {
        WriteLogPageController.to.resetInputs();

        Get.dialog(const WriteLogDialog());
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors().lineBlack.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_rounded,
              size: 48,
              color: AppColors().textGrey,
            ),
            Text(
              '항목 추가',
              style: TextStyle(
                color: AppColors().textGrey,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
