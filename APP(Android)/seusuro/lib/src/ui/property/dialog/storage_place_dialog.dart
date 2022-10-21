import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';

class StoragePlaceDialog extends StatelessWidget {
  const StoragePlaceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var isDesktop = DataController.to.isDesktop();

    var mobileWidth = DataController.to.mobileWidth;
    var screenWidth = DataController.to.screenWidth.value;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? mobileWidth : screenWidth,
        margin: EdgeInsets.only(
          left: screenWidth > mobileWidth + 480 ? 480 : 0,
        ),
        padding: const EdgeInsets.all(32),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '보관장소',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount:
                        PropertyPageController.to.storagePlaceList.length,
                    itemBuilder: (context, index) {
                      var storagePlace =
                          PropertyPageController.to.storagePlaceList[index];

                      return _storagePlaceTile(storagePlace);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 11),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storagePlaceTile(String storagePlace) {
    return Row(
      children: [
        Text(
          storagePlace,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Obx(() => Radio(
              value: storagePlace,
              groupValue: PropertyPageController.to.selectedStoragePlace.value,
              onChanged: (value) {
                PropertyPageController.to.selectedStoragePlace.value =
                    storagePlace;
              },
              activeColor: AppColors().bgBlack,
            )),
      ],
    );
  }
}
