import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';

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
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 32),
                          Flexible(
                            child: _filterButton(
                              content: '유효기간',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 32),
                          Flexible(
                            child: _filterButton(
                              content: '보관장소',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _propertyTile(),
                      _propertyTile(),
                      _propertyTile(),
                      _propertyTile(),
                      _propertyTile(),
                    ],
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
        // 정렬 순서
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

  Widget _propertyTile() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // 재산 상세 정보
          },
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors().bgGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '경구약',
                        style: TextStyle(
                          color: AppColors().textBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '아세트아미노펜',
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '유효기간',
                            style: TextStyle(
                              color: AppColors().textGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors().statusRed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '총 보유량',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '2500 EA',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors().textGrey,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: AppColors().lineGrey,
        ),
      ],
    );
  }
}
