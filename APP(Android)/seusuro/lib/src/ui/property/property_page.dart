import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/responsive_bottom_sheet.dart';
import 'package:seusuro/src/ui/property/dialog/category_dialog.dart';
import 'package:seusuro/src/ui/property/dialog/expiration_date_dialog.dart';
import 'package:seusuro/src/ui/property/dialog/storage_place_dialog.dart';
import 'package:seusuro/src/ui/property/property_tile.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PropertyPageController());

    return Column(
      children: [
        _appBar(),
        Expanded(
          child: Container(
            color: AppColors().bgWhite,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _totalNumber(),
                          const Spacer(),
                          _orderButton(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            child: _filterButton(
                              content: '분류',
                              onTap: () {
                                Get.dialog(const CategoryDialog());
                              },
                            ),
                          ),
                          const SizedBox(width: 32),
                          Flexible(
                            child: _filterButton(
                              content: '유효기간',
                              onTap: () {
                                Get.dialog(const ExpirationDateDialog());
                              },
                            ),
                          ),
                          const SizedBox(width: 32),
                          Flexible(
                            child: _filterButton(
                              content: '보관장소',
                              onTap: () {
                                Get.dialog(const StoragePlaceDialog());
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: PropertyPageController.to.propertyList.length,
                    itemBuilder: (context, index) {
                      PropertyInfo propertyInfo =
                          PropertyPageController.to.propertyList[index];

                      return PropertyTile(propertyInfo: propertyInfo);
                    },
                  ),
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
        '재산 현황',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _totalNumber() {
    return Row(
      children: [
        Text(
          '총',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '120',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '개',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _orderButton() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(_orderBottomSheet());
      },
      child: Row(
        children: [
          Obx(() => Text(
                PropertyPageController.to.selectedOrder.value,
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
    );
  }

  Widget _orderBottomSheet() {
    var orderList = PropertyPageController.to.orderList;

    return rBottomSheet(
      height: 244,
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
          _orderTile(orderList[0]),
          const SizedBox(height: 16),
          _orderTile(orderList[1]),
          const SizedBox(height: 16),
          _orderTile(orderList[2]),
        ],
      ),
    );
  }

  Widget _orderTile(String orderBy) {
    return InkWell(
      onTap: () {
        PropertyPageController.to.selectedOrder.value = orderBy;
        Get.back();
      },
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: Text(
          orderBy,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _filterButton({required String content, required Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors().lineBlack,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
