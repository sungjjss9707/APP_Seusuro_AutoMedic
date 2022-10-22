import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';
import 'package:seusuro/src/model/property_info.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/property/info/property_detail.dart';
import 'package:seusuro/src/ui/property/info/property_log.dart';

class PropertyInfoPage extends StatefulWidget {
  const PropertyInfoPage({
    Key? key,
    required this.propertyInfo,
  }) : super(key: key);

  final PropertyInfo propertyInfo;

  @override
  State<PropertyInfoPage> createState() => _PropertyInfoPageState();
}

class _PropertyInfoPageState extends State<PropertyInfoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors().lineGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  size: 48,
                  color: AppColors().bgWhite,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.propertyInfo.name,
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              indicatorWeight: 4,
              indicatorColor: AppColors().lineBlack,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors().bgBlack,
              unselectedLabelColor: AppColors().bgGrey,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: '재산 정보'),
                Tab(text: '로그 정보'),
              ],
            ),
            Container(
              height: 1,
              color: AppColors().lineGrey,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PropertyDetail(propertyInfo: widget.propertyInfo),
                  PropertyLog(propertyInfo: widget.propertyInfo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    var propertyId = widget.propertyInfo.id;

    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '상세 정보',
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
      actions: [
        IconButton(
          onPressed: () async {
            if (!isFavorite(propertyId)) {
              await PropertyPageController.to.addFavorite(propertyId);
            } else {
              await PropertyPageController.to.delFavorite(propertyId);
            }
          },
          icon: Obx(() => Icon(
                isFavorite(propertyId)
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: AppColors().bgBlack,
              )),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  bool isFavorite(String propertyId) {
    bool isFavorite = false;

    for (PropertyInfo propertyInfo in PropertyPageController.to.favoriteList) {
      if (propertyInfo.id == propertyId) {
        isFavorite = true;
        break;
      }
    }

    return isFavorite;
  }
}
