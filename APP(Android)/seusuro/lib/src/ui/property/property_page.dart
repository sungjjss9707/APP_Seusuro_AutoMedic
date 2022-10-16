import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/ui/property/property_list.dart';
import 'package:seusuro/src/repository/property_repository.dart';

class PropertyPage extends StatefulWidget {
  const PropertyPage({super.key});

  @override
  State<PropertyPage> createState() => PropertyPageState();
}

class PropertyPageState extends State<PropertyPage> {
  
  final _orderList = const ['가나다 순', '최신 등록 순', '유효기간 짧은 순'];

  static final _propertyList = PropertyList();

  int index = 0;
  late int? totalNum = _propertyList.totalNum;

  valueChanged(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertyPageController());

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                  children: [
                    const TextSpan(text: '총 '),
                    TextSpan(
                      text: totalNum.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      )
                    ),
                    const TextSpan(text: '개'),
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
                    Text(_orderList[PropertyPageController.to.orderIndex.value]),
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
                    openSortDialog(context);
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
        ),
        _propertyList,
      ],
    );
  }

  void openBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              height: 48,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(328, 48),
                  backgroundColor: PropertyPageController.to.orderIndex.value == 0 ? AppColors().bgGrey : Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
                onPressed: () {
                  setState(() {
                    PropertyPageController.to.changeOrderIndex(0);
                  });
                  Navigator.pop(context);
                },
                child: const Text('가나다 순'),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              height: 48,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(328, 48),
                  backgroundColor: PropertyPageController.to.orderIndex.value == 1 ? AppColors().bgGrey : Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
                onPressed: () {
                  setState(() {
                    PropertyPageController.to.changeOrderIndex(1);
                  });
                  Navigator.pop(context);
                },
                child: const Text('최신 등록 순'),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              height: 48,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(328, 48),
                  backgroundColor: PropertyPageController.to.orderIndex.value == 2 ? AppColors().bgGrey : Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                ),
                onPressed: () {
                  setState(() {
                    PropertyPageController.to.changeOrderIndex(2);
                  });
                  Navigator.pop(context);
                },
                child: const Text('유효기간 짧은 순'),
              ),
            ),
          ]
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    );
  }
}

void openSortDialog(BuildContext context) {
  Get.dialog(
    SimpleDialog(
      title: Text(
        '분류',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: AppColors().textBlack,
        )
      ),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '경구약',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textBlue,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeOrally.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeOrally.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '백신류',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textPurple,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeVaccine.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeVaccine.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '분무약',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textOrange,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeAerosol.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeAerosol.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '보호대',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textGreen,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeGuard.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeGuard.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '마스크',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textGrey,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeMask.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeMask.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '소모품',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors().textBrown,
                ),
              ),
              Checkbox(
                checkColor: AppColors().bgWhite,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: PropertyPageController.to.includeConsumable.value,
                onChanged: (bool? value) {
                  () {
                    PropertyPageController.to.includeConsumable.value = value!;
                  };
                }
              )
            ],
          ),
        ),
        TextButton(
          child: Text(
            '확인',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors().textBlack,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    )
  );
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interacitveStates = <MaterialState> {
    MaterialState.pressed,
  };
  if (states.any(interacitveStates.contains)) {
    return AppColors().bgBlack;
  }
  return AppColors().bgBlack;
}