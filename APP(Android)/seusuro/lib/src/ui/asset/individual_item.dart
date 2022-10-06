import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

Widget individualItem(String category, String name, int ea) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    alignment: Alignment.center,
    child: Row(
      children: [
        const SizedBox(
          height: 64,
          width: 64,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey
            ),
          )
        ),
        const SizedBox(width: 16),
        Container(
          width: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                name,
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
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '총 보유량',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              '${ea}EA',
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        const SizedBox(width: 32),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12
        )
      ]
    )
  );
}