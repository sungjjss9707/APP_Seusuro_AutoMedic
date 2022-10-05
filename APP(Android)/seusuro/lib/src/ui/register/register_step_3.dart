import 'package:flutter/material.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/custom_text_form_field.dart';
import 'package:seusuro/src/controller/ui/register_page_controller.dart';

class RegisterStep3 extends StatelessWidget {
  const RegisterStep3({
    Key? key,
    required this.formkey,
  }) : super(key: key);

  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      children: [
        const SizedBox(height: 64),
        Text(
          '소속 부대를 인증해주세요',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 64),
        Form(
          key: formkey,
          child: Column(
            children: [
              CustomTextFormField(
                content: '소속 부대',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '소속 부대를 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller:
                    RegisterPageController.to.militaryUnitEditingController,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                content: '접속 코드',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '접속 코드를 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller:
                    RegisterPageController.to.accessCodeEditingController,
                obscureText: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
