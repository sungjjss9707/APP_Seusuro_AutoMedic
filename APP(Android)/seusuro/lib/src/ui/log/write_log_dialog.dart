import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/write_log_page_controller.dart';
import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/responsive_bottom_sheet.dart';

class WriteLogDialog extends StatelessWidget {
  const WriteLogDialog({super.key});

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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '항목 추가',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _inputName(),
                  const SizedBox(height: 16),
                  _inputCategory(),
                  const SizedBox(height: 16),
                  _inputAmount(),
                  const SizedBox(height: 16),
                  _inputExpirationDate(),
                  const SizedBox(height: 16),
                  _inputStoragePlace(),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      var name =
                          WriteLogPageController.to.nameEditingController.text;
                      var amount = int.parse(WriteLogPageController
                          .to.amountEditingController.text);
                      var unit = WriteLogPageController.to.unit.value;
                      var category = WriteLogPageController.to.category.value;
                      var storagePlace = WriteLogPageController
                          .to.storagePlaceEditingController.text;
                      var expirationDate =
                          WriteLogPageController.to.expirationDate.value;

                      if (name.isNotEmpty &&
                          amount > 0 &&
                          unit.isNotEmpty &&
                          category.isNotEmpty &&
                          storagePlace.isNotEmpty &&
                          expirationDate != DateTime(2000, 1, 1)) {
                        var itemInfo = ItemInfo(
                          name,
                          amount,
                          unit,
                          category,
                          storagePlace,
                          expirationDate,
                        );

                        WriteLogPageController.to.itemList.add(itemInfo);

                        Get.back();
                      }
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

  Widget _inputName() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '품명',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: WriteLogPageController.to.nameEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '품명을 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputCategory() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '분류',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Get.bottomSheet(_categoryBottomSheet());
            },
            child: Obx(() => Text(
                  WriteLogPageController.to.category.value.isEmpty
                      ? '분류를 입력하세요'
                      : WriteLogPageController.to.category.value,
                  style: TextStyle(
                    color: WriteLogPageController.to.category.value.isEmpty
                        ? AppColors().textGrey
                        : AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget _categoryBottomSheet() {
    var categoryList = WriteLogPageController.to.categoryList;

    return rBottomSheet(
      height: 240,
      color: AppColors().bgWhite,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors().lineGrey,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 196,
            child: CupertinoPicker(
              itemExtent: 48,
              magnification: 1.2,
              scrollController: FixedExtentScrollController(initialItem: 0),
              onSelectedItemChanged: (int index) {
                WriteLogPageController.to.category.value = categoryList[index];
              },
              children: List.generate(categoryList.length, (int index) {
                return Center(
                  child: Text(
                    categoryList[index],
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputAmount() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '수량',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: WriteLogPageController.to.amountEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '수량을 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        SizedBox(
          width: 48,
          child: InkWell(
            onTap: () {
              Get.bottomSheet(_unitBottomSheet());
            },
            child: Row(
              children: [
                Obx(() => Text(
                      WriteLogPageController.to.unit.value,
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                const SizedBox(width: 4),
                const Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _unitBottomSheet() {
    var unitList = WriteLogPageController.to.unitList;

    return rBottomSheet(
      height: 240,
      color: AppColors().bgWhite,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors().lineGrey,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 196,
            child: CupertinoPicker(
              itemExtent: 48,
              magnification: 1.2,
              scrollController: FixedExtentScrollController(initialItem: 0),
              onSelectedItemChanged: (int index) {
                WriteLogPageController.to.unit.value = unitList[index];
              },
              children: List.generate(unitList.length, (int index) {
                return Center(
                  child: Text(
                    unitList[index],
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputExpirationDate() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '유효기간',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var expirationDate = await showDatePicker(
                context: Get.overlayContext!,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022, 3, 21),
                lastDate: DateTime(2030, 12, 31),
              );

              if (expirationDate != null) {
                WriteLogPageController.to.expirationDate.value = expirationDate;
              }
            },
            child: Obx(() => Text(
                  WriteLogPageController.to.expirationDate.value ==
                          DateTime(2000, 1, 1)
                      ? '유효기간을 입력하세요'
                      : DateFormat('yyyy년 MM월 dd일').format(
                          WriteLogPageController.to.expirationDate.value),
                  style: TextStyle(
                    color: WriteLogPageController.to.expirationDate.value ==
                            DateTime(2000, 1, 1)
                        ? AppColors().textGrey
                        : AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget _inputStoragePlace() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '보관장소',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: WriteLogPageController.to.storagePlaceEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '보관장소를 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
