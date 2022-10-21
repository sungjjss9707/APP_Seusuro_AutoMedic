import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';

class CategoryDialog extends StatelessWidget {
  const CategoryDialog({super.key});

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
                    '분류',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: PropertyPageController.to.categoryMap.length,
                    itemBuilder: (context, index) {
                      var categoryMap = PropertyPageController.to.categoryMap;
                      var category = categoryMap.keys.toList()[index];

                      return _categoryTile(
                        category,
                        categoryMap[category],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 11),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: PropertyPageController
                              .to.selectedCategories.clear,
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
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            if (await PropertyPageController.to
                                .getProperties()) {
                              Get.back();
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

  Widget _categoryTile(String category, Color? textColor) {
    return Row(
      children: [
        Text(
          category,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Obx(() => Checkbox(
              value: PropertyPageController.to.selectedCategories
                  .contains(category),
              onChanged: (value) {
                if (!PropertyPageController.to.selectedCategories
                    .contains(category)) {
                  PropertyPageController.to.selectedCategories.add(category);
                } else {
                  PropertyPageController.to.selectedCategories.remove(category);
                }
              },
              activeColor: AppColors().bgBlack,
            )),
      ],
    );
  }
}
