import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/main_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/asset/asset_page.dart';
import 'package:seusuro/src/ui/log/log_page.dart';
import 'package:seusuro/src/ui/mypage/mypage_page.dart';
import 'package:seusuro/src/ui/search/search_page.dart';
import 'package:seusuro/src/ui/asset/bookmark_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainPageController());
    
    return rScaffold(
      rAppBar: _appBar(),
      rBody: Obx(() {
        switch (MainPageController.to.currentIndex.value) {
          case 0:
            return const LogPage();
          case 1:
            return const AssetPage();
          case 2:
            return const SearchPage();
          case 3:
            return const MypagePage();
          default:
            return Container();
        }
      }),
      rBottomNavigationBar: _bottomNavigationBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Obx(() {
        var title = '수불 로그';

        switch (MainPageController.to.currentIndex.value) {
          case 0:
            title = '수불 로그';
            break;
          case 1:
            title = '재산 현황';
            break;
          case 2:
            title = '약품 검색';
            break;
          case 3:
            title = '마이페이지';
            break;
        }

        return Text(
          title,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        );
      }),
      actions: [
        Obx(() {
          switch(MainPageController.to.currentIndex.value) {
            case 1:
              return IconButton(
                onPressed: () {

                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  size: 20,
                  color: AppColors().textBlack
                ),
              );
            default:
              return Container();
          }
        }),
        Obx(() {
          switch(MainPageController.to.currentIndex.value) {
            case 1:
              return IconButton(
                onPressed: () {
                  Get.to(() => BookMarkPage());
                },
                icon: Icon(
                  Icons.star_outline_rounded,
                  size: 20,
                  color: AppColors().textBlack
                ),
              );
            default:
              return Container();
          }
        }),
        Obx(() {
          switch(MainPageController.to.currentIndex.value) {
            case 1:
              return IconButton(
                onPressed: () {

                },
                icon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors().textBlack
                ),
              );
            default:
              return Container();
          }
        }),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return Column(
      children: [
        Container(
          height: 1,
          color: AppColors().lineGrey,
        ),
        SizedBox(
          height: 64,
          child: Obx(() => BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                backgroundColor: AppColors().bgWhite,
                selectedItemColor: AppColors().textBlack,
                unselectedItemColor: AppColors().textGrey,
                currentIndex: MainPageController.to.currentIndex.value,
                onTap: MainPageController.to.changePageIndex,
                items: [
                  bottomNavigationBarItem('수불 로그', Icons.swap_vert_rounded),
                  bottomNavigationBarItem('재산 현황', Icons.dashboard_rounded),
                  bottomNavigationBarItem('약품 검색', Icons.vaccines),
                  bottomNavigationBarItem('마이페이지', Icons.person_rounded),
                ],
              )),
        ),
      ],
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem(var label, var iconName) {
    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(
          iconName,
          color: AppColors().textGrey,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(
          iconName,
          color: AppColors().textBlack,
        ),
      ),
    );
  }
}
