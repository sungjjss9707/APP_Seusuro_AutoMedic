import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/asset_page_controllet.dart';

class AssetPage extends StatelessWidget {
  const AssetPage({super.key});

  final _orderList = const ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];

  @override
  Widget build(BuildContext context) {
      Get.put(AssetPageController());

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
                onPressed: openBottomSheet,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black
                ),
                child: Row(
                  children: [
                    Text(_orderList[AssetPageController.to.orderIndex.value]),
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

        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 88,
                height: 36,
                child: OutlinedButton(
                  onPressed: () {

                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(color: Colors.black)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
                    ),
                  ),
                  child: const Text('분류'),
                ),
              ),
              SizedBox(
                width: 88,
                height: 36,
                child: OutlinedButton(
                  onPressed: () {

                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(color: Colors.black)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
                    ),
                  ),
                  child: const Text('유효기간'),
                ),
              ),
              SizedBox(
                width: 88,
                height: 36,
                child: OutlinedButton(
                  onPressed: () {

                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(color: Colors.black)),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
                    ),
                  ),
                  child: const Text('보관장소'),
                ),
              )
            ],
          )
        )
      ],
    );
  }

  void openBottomSheet() {
    Get.bottomSheet(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('가나다 순'),
          ),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('최신 등록 순'),
          ),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('유효기간 순'),
          ),
        ]
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
