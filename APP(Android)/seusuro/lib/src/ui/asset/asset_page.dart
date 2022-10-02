import 'package:flutter/material.dart';

class AssetPage extends StatelessWidget {
  const AssetPage({super.key});

  final _valueList = ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];
  var _selectedValue = '가나다순';

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: '총 '
                ),
                TextSpan(
                  text: '$totalNum',
                  style: TextStyle(
                    fontWeight: FontWeight.w400
                  )
                ),
                TextSpan(
                  text:'개'
                ),
              ]
            ),
            
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween
        )
      ],
    )
  }
}
