import 'package:flutter/material.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/app_colors.dart';

class Detail extends StatelessWidget {
  const Detail(String this._name, {super.key});
  
  final _name;

  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: _appBar(),
      rBody: _body(_name)
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

Widget _body(String name) {
  return Column(
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
  );
}