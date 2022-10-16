import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  final String content;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors().bgBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: AppColors().textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
