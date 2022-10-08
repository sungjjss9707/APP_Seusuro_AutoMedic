import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

Widget item(String category, String name, String unit, int ea) {
  return TextButton(
    onPressed: () {
      
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
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textColor(category),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors().textBlack,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '유효기간 ',
                        style: TextStyle(
                          color: AppColors().textBlack,
                        )
                      ),
                      WidgetSpan(
                        child: Icon(Icons.circle,
                          size: 12,
                          color: AppColors().statusGreen
                        )
                      )
                    ]
                  )
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
                '${ea}${unit}',
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