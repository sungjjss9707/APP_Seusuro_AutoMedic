import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/property/info/property_info_page.dart';

class PropertyTile extends StatelessWidget {
  const PropertyTile({
    Key? key,
    required this.propertyInfo,
  }) : super(key: key);

  final PropertyInfo propertyInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => PropertyInfoPage(propertyInfo: propertyInfo),
                transition: rTransition());
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
                    color: AppColors().lineGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medication_rounded,
                    size: 36,
                    color: AppColors().bgWhite,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertyInfo.category,
                        style: TextStyle(
                          color: PropertyPageController
                              .to.categoryMap[propertyInfo.category],
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        propertyInfo.name,
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
                              color: _statusColor(),
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
                      '${propertyInfo.totalAmount.toString()} ${propertyInfo.unit}',
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

  Color _statusColor() {
    var statusColor = AppColors().statusGreen;

    DateTime expirationDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(propertyInfo.expirationDate);

    if (expirationDate.difference(DateTime.now()) > const Duration(days: 365)) {
      statusColor = AppColors().statusGreen;
    } else if (expirationDate.difference(DateTime.now()) >
        const Duration(days: 180)) {
      statusColor = AppColors().statusYellow;
    } else {
      statusColor = AppColors().statusRed;
    }

    return statusColor;
  }
}
