import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.content,
    required this.validator,
    required this.controller,
    this.obscureText,
  }) : super(key: key);

  final String content;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final bool? obscureText;

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
        TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText ?? false,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors().bgBlack,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: AppColors().lineBlack,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: AppColors().lineBlack,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
