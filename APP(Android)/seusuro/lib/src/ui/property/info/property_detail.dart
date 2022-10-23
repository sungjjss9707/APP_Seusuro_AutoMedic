import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/ui/property/info/amount_by_place_chart.dart';

class PropertyDetail extends StatelessWidget {
  const PropertyDetail({
    Key? key,
    required this.propertyInfo,
  }) : super(key: key);

  final PropertyInfo propertyInfo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(32),
      children: [
        Text(
          '기본 정보',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        _detailTile(title: '분류', content: propertyInfo.category),
        const SizedBox(height: 16),
        _detailTile(title: 'NIIN', content: propertyInfo.niin),
        const SizedBox(height: 16),
        _detailTile(
          title: '총량',
          content:
              '${propertyInfo.totalAmount.toString()} ${propertyInfo.unit}',
        ),
        const SizedBox(height: 16),
        _detailTile(
          title: '유효기간',
          content:
              '${propertyInfo.expirationDate.substring(0, 10).replaceRange(4, 5, '년 ').replaceRange(8, 9, '월 ')}일',
        ),
        const SizedBox(height: 32),
        Text(
          '장소별 보유량',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        AspectRatio(
          aspectRatio: 1.2,
          child: AmountByPlaceChart(
            amountByPlace: propertyInfo.amountByPlace,
          ),
        ),
      ],
    );
  }

  Widget _detailTile({
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            title,
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          content,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
