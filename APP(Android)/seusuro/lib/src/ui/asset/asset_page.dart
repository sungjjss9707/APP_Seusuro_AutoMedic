import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class AssetPage extends StatelessWidget {
  const AssetPage({super.key});

  final _valueList = const ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  children: const [
                    TextSpan(text: '총 '),
                    TextSpan(
                      text: '164',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      )
                    ),
                    TextSpan(text: '개'),
                  ]
                )
              ),
              TextButton(
                onPressed: () {

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black
                ),
                child: Row(
                  children: [
                    Text(_valueList[0]),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 24
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
