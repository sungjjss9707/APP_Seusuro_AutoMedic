import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/ui/asset/tab_page.dart';
import 'package:time_machine/time_machine.dart';

Widget item(Map<String, dynamic> assetInfo) {
  return TextButton(
    onPressed: () {
      Get.to(() => TabPage(assetInfo));
    },
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero
    ),
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors().bgGrey,
              ),
            )
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 135,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assetInfo['category'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: textColor(assetInfo['category']),
                  ),
                ),
                Text(
                  assetInfo['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors().textBlack,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '유효기간 ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColors().textGrey,
                      )
                    ),
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: statusColor(assetInfo['expirationDate']),
                    ),
                  ],
                )
              ]
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '총 보유량',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors().textBlack
                ),
              ),
              Text(
                '${assetInfo['totalAmount']}${assetInfo['unit']}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors().textBlack,
                ),
              )
            ],
          ),
          const SizedBox(width: 32),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: AppColors().textBlack,
          )
        ]
      ),
    ),
  );
}

Color statusColor(DateTime expirationDate) {
  LocalDate expDate = LocalDate.dateTime(expirationDate);
  LocalDate curr = LocalDate.today();
  Period diff = expDate.periodSince(curr);
  if (diff.years == 0 && diff.months < 6) {
    return AppColors().statusRed;
  } else if (diff.years == 0 && diff.months >= 6) {
    return AppColors().statusYellow;
  } else if (diff.years >= 1) {
    return AppColors().statusGreen;
  } else {
    return AppColors().bgWhite;
  }
}

Color textColor(String category) {
  if (category == '경구약') {
    return AppColors().textBlue;
  }
  else if (category == '백신류') {
    return AppColors().textPurple;
  }
  else if (category == '분무약') {
    return AppColors().textOrange;
  }
  else if (category == '보호대') {
    return AppColors().textGreen;
  }
  else if (category == '마스크') {
    return AppColors().textGrey;
  }
  else if (category == '소모품') {
    return AppColors().textBrown;
  }
  else {
    return AppColors().textBlack;
  }
}