import 'package:flutter/material.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/ui/property/tabbarpage/asset_info_page.dart';
import 'package:seusuro/src/ui/property/tabbarpage/log_info_page.dart';

class TabPage extends StatefulWidget {
  final Map<String, dynamic> assetInfo;
  const TabPage(Map<String, dynamic> this.assetInfo, {super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: appBar(context),
      rBody: body(context, widget.assetInfo, _tabController)
    );
  }

}

AppBar appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors().bgWhite,
    title: Text(
      '상세 정보',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors().textBlack,
      )
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        size: 20,
        color: AppColors().textBlack
      )
    ),
    actions: [
      ToggleIconButton(false),
    ]
  );
}

Widget body(BuildContext context, Map<String, dynamic> assetInfo, TabController tabController) {
  return SizedBox(
    height: MediaQuery.of(context).size.height - 56,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Container(color: AppColors().bgGrey),
              ),
              const SizedBox(height: 8),
              Text(
                assetInfo['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )
              )
            ],
          ),
        ),
        TabBar(
          controller: tabController,
          indicatorColor: AppColors().textBlack,
          isScrollable: true,
          tabs: const [
            Tab(text: '재산 정보'),
            Tab(text: '로그 정보'),
          ]
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              assetInfoPage(assetInfo),
              logInfoPage(context, assetInfo['logRecord']),
            ],
          )
        )
      ],
    ),
  );
}

class ToggleIconButton extends StatefulWidget {
  bool isBookmarked;
  ToggleIconButton(this.isBookmarked, {super.key});
  
  @override
  State<ToggleIconButton> createState() => ToggleIconButtonState();

}

class ToggleIconButtonState extends State<ToggleIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      icon: widget.isBookmarked == true ? Icon(Icons.star, color: AppColors().textBlack) : Icon(Icons.star_outline_rounded, color: AppColors().textBlack),
      onPressed: () {
        setState() {
          () {
            widget.isBookmarked = !widget.isBookmarked;
          };
        }
      },
    );
  }

}