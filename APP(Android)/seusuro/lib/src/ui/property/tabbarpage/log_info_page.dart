import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

Widget logInfoPage(BuildContext context, List<String> logRecord) {
  return SizedBox(
    height: MediaQuery.of(context).size.height - 288,
    child: ListView.separated(
      itemCount: logRecord.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(22.0),
          child: log(logRecord[index]),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    ),
  );
}

Widget log(String info) {
  List<String> parsedInfo = info.split(' ');

  return Row(
    children: [
      Text(
        '${parsedInfo[0]} ${parsedInfo[1]} ${parsedInfo[2]}',
        style: TextStyle(
          fontSize: 16,
          color: AppColors().textBlack,
        ),
      ),
      const SizedBox(width: 56),
      Text(
        parsedInfo[3],
        style: TextStyle(
          fontSize: 16,
          color: textColor(parsedInfo[3]),
        )
      ),
      const SizedBox(width: 16),
      Text(
        parsedInfo[4],
        style: TextStyle(
          fontSize: 16,
          color: AppColors().textBlack,
        )
      )
    ],
  );
}

Color textColor(String type) {
  switch(type) {
    case '수입':
      return AppColors().keyBlue;
    case '불출':
      return AppColors().keyRed;
    default:
      return AppColors().textBlack;
  }
}