import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/bookmark_page_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/search/drug_info_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BookmarkPageController());

    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: Expanded(
          child: BookmarkPageController.to.obx(
            (state) {
              if (BookmarkPageController.to.bookmarkList.isEmpty) {
                return Center(
                  child: Text(
                    '북마크한 약품이 없습니다',
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
                  itemCount: BookmarkPageController.to.bookmarkList.length,
                  itemBuilder: (context, index) {
                    var bookmarkList = BookmarkPageController.to.bookmarkList;

                    return _drugTile(drugInfo: bookmarkList[index]);
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
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '북마크',
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

  Widget _drugTile({required DrugInfo drugInfo}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => DrugInfoPage(drugInfo: drugInfo),
                transition: rTransition());
          },
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                drugInfo.itemImage == null
                    ? Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors().lineGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medication_rounded,
                          size: 36,
                          color: AppColors().bgWhite,
                        ),
                      )
                    : ImageNetwork(
                        width: 64,
                        height: 64,
                        image: drugInfo.itemImage!,
                        onTap: () {
                          Get.to(() => DrugInfoPage(drugInfo: drugInfo),
                              transition: rTransition());
                        },
                        onLoading: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors().keyGrey,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drugInfo.itemName!,
                        style: TextStyle(
                          color: AppColors().bgBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drugInfo.entpName!,
                        style: TextStyle(
                          color: AppColors().textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: AppColors().lineGrey,
        ),
      ],
    );
  }
}
