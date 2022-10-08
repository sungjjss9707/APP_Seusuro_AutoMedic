import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget assetInfoPage(Map<String, dynamic> json) {
  String expirationDate = DateFormat('yyyy년 MM월 dd일').format(json['expirationDate']); 

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text('기본 정보', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors().textBlack,
              ))
        ],
      ),
      Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  '분류',
                  style: TextStyle(color: AppColors().textGrey),
                )
              ),
              Text(json['category']),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  'NIIN',
                  style: TextStyle(color: AppColors().textGrey),
                )
              ),
              Text(json['niin']),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  '총량',
                  style: TextStyle(color: AppColors().textGrey),
                )
              ),
              Text('${json['totalAmount']} ${'unit'}')
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  '유효기간',
                  style: TextStyle(color: AppColors().textGrey),
                )
              ),
              Text(expirationDate),
            ],
          ),
        ],
      ),
      const Text(
        '장소별 보유량',
        style: TextStyle(fontWeight: FontWeight.w900)
      ),
      barChart(json['amountByPlace']),
    ],
  );
}

SfCartesianChart barChart(List<Map<String, dynamic>> amountByPlace) {
  List<ChartData> chartData = [];

  for (int i = 0; i < amountByPlace.length; i++) {
    chartData.add(ChartData(amountByPlace[i]['storagePlace'], amountByPlace[i]['amount']));
  }

  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: <ChartSeries>[
      ColumnSeries<ChartData, String> (
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.storagePlace,
        yValueMapper: (ChartData data, _) => data.quantity
      )
    ]
  );
}

class ChartData {
  ChartData(this.storagePlace, this.quantity);
  String storagePlace;
  int quantity;
}
