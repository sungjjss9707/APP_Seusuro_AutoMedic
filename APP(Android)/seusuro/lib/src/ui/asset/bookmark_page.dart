import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/asset/item.dart';

List<dynamic> testAssets = [
  {
    'id': '1234567890',
    'name': '아세트아미노펜',
    'unit': 'EA',
    'totalAmount': 2500,
    'category': '경구약',
    'niin': '1234567890',
    'amountByPlace': [
      {
        'storagePlace': '약장함 1',
        'amount': 1900
      },
      {
        'storagePlace': '약장함 2',
        'amount': 600
      },
    ],
    'expirationDate': DateTime(2022, 10, 27),
  },
  {
    'id': '1234567890',
    'name': '벤토린에보할러',
    'unit': 'EA',
    'totalAmount': 12,
    'category': '분무약',
    'niin': '1234567890',
    'amountByPlace': [
      {
        'storagePlace': '약장함 1',
        'amount': 1900
      },
      {
        'storagePlace': '약장함 2',
        'amount': 600
      },
    ],
    'expirationDate': DateTime(2022, 10, 27),
  },
  {
    'id': '1234567890',
    'name': '하브릭스주',
    'unit': 'EA',
    'totalAmount': 20,
    'category': '백신류',
    'niin': '1234567890',
    'amountByPlace': [
      {
        'storagePlace': '약장함 1',
        'amount': 1900
      },
      {
        'storagePlace': '약장함 2',
        'amount': 600
      },
    ],
    'expirationDate': DateTime(2022, 10, 27),
  },
];

class BookMarkPage extends StatefulWidget {
  @override
  State<BookMarkPage> createState() => BookMarkPageState();

}

class BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: rAppBar(context),
      rBody: rBody(context, testAssets),
    );
  }
}

AppBar rAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors().bgWhite,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        size: 16,
        color: AppColors().textBlack,
      ),
    ),
    title: Text(
      '즐겨찾기',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors().textBlack,
      )
    )
  );
}

Widget rBody(BuildContext context, List<dynamic> bookmarkedAssets) {
  return SizedBox(
    height: MediaQuery.of(context).size.height - 56,
    child: ListView.separated(
      itemCount: bookmarkedAssets.length,
      itemBuilder: (context, index) {
        return Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.20,
            children: [
              SlidableAction(
                onPressed: (context) {

                },
                backgroundColor: AppColors().bgRed,
                foregroundColor: AppColors().textWhite,
                icon: Icons.delete,
                label: '삭제',
              )
            ]
          ),
          child: item(bookmarkedAssets[index])
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1.0);
      },
    )
  );
}