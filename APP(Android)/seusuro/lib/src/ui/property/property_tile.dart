import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/model/property_info.dart';

class PropertyTile extends StatelessWidget {
  const PropertyTile({Key? key, required this.propertyInfo}) : super(key: key);

  final PropertyInfo propertyInfo;

  @override
  Widget build(BuildContext context) {
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
                          color: AppColors().textBlue,
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
}
