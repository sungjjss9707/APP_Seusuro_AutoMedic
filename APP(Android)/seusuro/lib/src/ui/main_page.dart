import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/main_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/log/log_page.dart';
import 'package:seusuro/src/ui/mypage/mypage_page.dart';
import 'package:seusuro/src/ui/property/property_page.dart';
import 'package:seusuro/src/ui/search/bookmark_page.dart';
import 'package:seusuro/src/ui/search/search_page.dart';

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
            return const PropertyPage();
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
          var actionList = <Widget>[];

          switch (MainPageController.to.currentIndex.value) {
            case 0:
              // 수불 로그
              actionList.add(
                IconButton(
                  onPressed: () {
                    Get.dialog(_logFilterDialog());
                  },
                  icon: Icon(
                    Icons.filter_alt_rounded,
                    color: AppColors().bgBlack,
                  ),
                ),
              );
              break;
            case 1:
              // 재산 현황
              break;
            case 2:
              // 약품 검색
              actionList.add(
                IconButton(
                  onPressed: () {
                    Get.to(() => const BookmarkPage(),
                        transition: rTransition());
                  },
                  icon: Icon(
                    Icons.bookmark_outline_rounded,
                    color: AppColors().bgBlack,
                  ),
                ),
              );
              break;
            case 3:
              // 마이페이지
              break;
          }

          actionList.add(const SizedBox(width: 8));

          return Row(children: actionList);
        }),
      ],
    );
  }

  Widget _logFilterDialog() {
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '로그 필터',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '로그 종류',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 36,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors().lineBlack,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '수입',
                          style: TextStyle(
                            color: AppColors().textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '날짜 선택',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      await showDatePicker(
                        context: Get.overlayContext!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022, 3, 21),
                        lastDate: DateTime(2030, 12, 31),
                      );
                    },
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: AppColors().lineBlack,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        '2022년 10월 29일',
                        style: TextStyle(
                          color: AppColors().textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
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
                      textAlign: TextAlign.center,
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
