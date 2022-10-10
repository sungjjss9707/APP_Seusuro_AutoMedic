import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

Widget assetInfoPage(Map<String, dynamic> assetInfo) {
  String expirationDate = DateFormat('yyyy년 MM월 dd일').format(assetInfo['expirationDate']); 

  return Container(
    margin: const EdgeInsets.all(32.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('기본 정보', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 4),
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
                Text(assetInfo['category']),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    'NIIN',
                    style: TextStyle(color: AppColors().textGrey),
                  )
                ),
                Text(assetInfo['niin']),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    '총량',
                    style: TextStyle(color: AppColors().textGrey),
                  )
                ),
                Text('${assetInfo['totalAmount']} ${assetInfo['unit']}')
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    '유효기간',
                    style: TextStyle(color: AppColors().textGrey),
                  )
                ),
                const SizedBox(width: 8),
                Text(expirationDate),
                warningSign(assetInfo['expirationDate']),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          '장소별 보유량',
          style: TextStyle(fontWeight: FontWeight.w900)
        ),
        barChart(assetInfo['amountByPlace']),
      ],
    ),
  );
}

Widget warningSign(DateTime expirationDate) {
  LocalDate expDate = LocalDate.dateTime(expirationDate);
  LocalDate curr = LocalDate.today();
  Period diff = expDate.periodSince(curr);
  if (diff.years == 0 && diff.months < 6) {
    return Icon(
      Icons.warning_amber_rounded,
      color: AppColors().statusRed,
      size: 20,
    );
  } else {
    return Container();
  }
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
        yValueMapper: (ChartData data, _) => data.quantity,
        dataLabelSettings: const DataLabelSettings(
          labelAlignment: ChartDataLabelAlignment.top,
          isVisible: true,
        ),
        width: 0.4,
        color: AppColors().chartGrey,
      )
    ]
  );
}

class ChartData {
  ChartData(this.storagePlace, this.quantity);
  String storagePlace;
  int quantity;
}
