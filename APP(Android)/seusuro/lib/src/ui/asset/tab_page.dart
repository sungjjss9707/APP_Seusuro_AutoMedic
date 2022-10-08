import 'package:flutter/material.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/app_colors.dart';

class TabPage extends StatefulWidget {
  const TabPage(String this._name, {super.key});

  final _name;

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
      rAppBar: _appBar(),
      rBody: _body(widget._name, _tabController)
    );
  }

}

AppBar _appBar() {
  return AppBar(
    title: const Text(
      '상세 정보',
      style: TextStyle(fontWeight: FontWeight.w700)
    ),
    leading: IconButton(
      onPressed: () {

      },
      icon: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 12,
        color: AppColors().textBlack
      )
    ),
    actions: [
      IconButton(
        onPressed: () {

        },
        icon: Icon(
          Icons.star_outline_rounded,
          size: 12,
          color: AppColors().textBlack
        )
      )
    ]
  );
}

Widget _body(String name, TabController tabController) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        height: 152,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 120,
              height: 120,
            ),
            Text(
              name,
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
      Container(
        margin: const EdgeInsets.all(32.0),
        child: TabBarView(
          controller: tabController,
          children: [
            
          ],
        )
      )
    ],
  );
}