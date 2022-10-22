import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class AmountByPlaceChart extends StatelessWidget {
  const AmountByPlaceChart({
    Key? key,
    required this.amountByPlace,
  }) : super(key: key);

  final List amountByPlace;

  @override
  Widget build(BuildContext context) {
    var maxY = 0.0;

    for (var element in amountByPlace) {
      if (element['amount'] > maxY) {
        maxY = element['amount'];
      }
    }

    return BarChart(
      BarChartData(
        maxY: maxY * 1.5,
        barGroups: barGroups,
        titlesData: titlesData,
        borderData: borderData,
        barTouchData: barTouchData,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceEvenly,
      ),
    );
  }

  List<BarChartGroupData> get barGroups => List.generate(
        amountByPlace.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: amountByPlace[index]['amount'],
              width: 16,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(0),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors().keyRed,
          AppColors().keyBlue,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        amountByPlace[value.toInt()]['storagePlace'],
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: AppColors().textBlack,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
      );
}
