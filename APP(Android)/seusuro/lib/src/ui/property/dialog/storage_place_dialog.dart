import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/property/pdf/pdf_preview_page.dart';

class StoragePlaceDialog extends StatelessWidget {
  const StoragePlaceDialog({
    Key? key,
    this.exportAsPdf = false,
  }) : super(key: key);

  final bool exportAsPdf;

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
                    !exportAsPdf ? '보관장소' : '인쇄할 보관장소를 고르세요',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: !exportAsPdf ? 20 : 18,
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
                  Row(
                    children: [
                      !exportAsPdf
                          ? Flexible(
                              child: InkWell(
                                onTap: () {
                                  PropertyPageController
                                      .to.selectedStoragePlace.value = '';
                                },
                                child: Center(
                                  child: Text(
                                    '초기화',
                                    style: TextStyle(
                                      color: AppColors().textBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (await PropertyPageController.to
                                .getProperties(exportAsPdf: exportAsPdf)) {
                              Get.back();

                              if (exportAsPdf) {
                                Get.to(() => const PdfPreviewPage(),
                                    transition: rTransition());
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                color: AppColors().textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
              groupValue: !exportAsPdf
                  ? PropertyPageController.to.selectedStoragePlace.value
                  : PropertyPageController.to.pdfStoragePlace.value,
              onChanged: (value) {
                !exportAsPdf
                    ? PropertyPageController.to.selectedStoragePlace.value =
                        storagePlace
                    : PropertyPageController.to.pdfStoragePlace.value =
                        storagePlace;
              },
              activeColor: AppColors().bgBlack,
            )),
      ],
    );
  }
}
