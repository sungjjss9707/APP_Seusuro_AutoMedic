import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

Widget individualItem(String category, String productName, int ea) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    alignment: Alignment.center,
    child: Row(
      children: [
        const SizedBox(
          height: 64,
          width: 64
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(category),
            Text(
              productName,
              style: const TextStyle(fontWeight: FontWeight.w700)
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: '유효기간'),
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
        const SizedBox(width: 44),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '총 보유량',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              '{$ea}EA',
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        const SizedBox(width: 32),
        const Icon(
          Icons.arrow_forward,
          size: 24
        )
      ]
    )
  );
}