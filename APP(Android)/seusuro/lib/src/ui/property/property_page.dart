import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appBar(),
        const Expanded(
          child: Center(
            child: Text('재산 현황'),
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '재산 현황',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
