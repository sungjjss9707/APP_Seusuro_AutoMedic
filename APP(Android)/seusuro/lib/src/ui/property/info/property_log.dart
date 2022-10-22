import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/model/item_info.dart';
import 'package:seusuro/src/model/log_info.dart';
import 'package:seusuro/src/model/property_info.dart';

class PropertyLog extends StatelessWidget {
  const PropertyLog({
    Key? key,
    required this.propertyInfo,
  }) : super(key: key);

  final PropertyInfo propertyInfo;

  @override
  Widget build(BuildContext context) {
    var logList = PropertyPageController.to.logList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: logList.length,
      itemBuilder: (context, index) {
        LogInfo logInfo = logList[index];

        ItemInfo? itemInfo;

        for (ItemInfo item in logInfo.items) {
          if (propertyInfo.name == item.name) itemInfo = item;
        }

        return _logTile(
          logInfo: logInfo,
          itemInfo: itemInfo,
        );
      },
    );
  }

  Widget _logTile({
    required LogInfo logInfo,
    required ItemInfo? itemInfo,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Text(
            '${logInfo.createdAt.substring(0, 10).replaceRange(4, 5, '년 ').replaceRange(8, 9, '월 ')}일',
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            logInfo.receiptPayment,
            style: TextStyle(
              color: _keyColor(logInfo.receiptPayment),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 64,
            child: Text(
              '${itemInfo!.amount.toString()} ${itemInfo.unit}',
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _keyColor(String receiptPayment) {
    Color keyColor;

    switch (receiptPayment) {
      case '수입':
        keyColor = AppColors().keyBlue;
        break;
      case '불출':
        keyColor = AppColors().keyRed;
        break;
      case '반납':
        keyColor = AppColors().keyGreen;
        break;
      case '폐기':
        keyColor = AppColors().keyGrey;
        break;
      default:
        keyColor = AppColors().keyBlue;
        break;
    }

    return keyColor;
  }
}
