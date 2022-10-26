import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class CustomInputButton extends StatelessWidget {
  const CustomInputButton({
    Key? key,
    required this.content,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  final String content;
  final String buttonText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            content,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColors().lineBlack.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: AppColors().textBlack,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        )
      ],
    );
  }
}
