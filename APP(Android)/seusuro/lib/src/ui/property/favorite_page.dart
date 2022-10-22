import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/property/property_tile.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: PropertyPageController.to.obx(
          (state) {
            if (PropertyPageController.to.favoriteList.isEmpty) {
              return Center(
                child: Text(
                  '즐겨찾기한 재산이 없습니다',
                  style: TextStyle(
                    color: AppColors().bgBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: PropertyPageController.to.favoriteList.length,
                itemBuilder: (context, index) {
                  var propertyInfo =
                      PropertyPageController.to.favoriteList[index];

                  return PropertyTile(propertyInfo: propertyInfo);
                },
              );
            }
          },
          onLoading: Center(
            child: CircularProgressIndicator(
              color: AppColors().keyBlue,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '즐겨찾기',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: Get.back,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors().bgBlack,
        ),
      ),
    );
  }
}
