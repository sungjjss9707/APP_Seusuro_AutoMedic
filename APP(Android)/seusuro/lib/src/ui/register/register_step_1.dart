import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/custom_text_form_field.dart';
import 'package:seusuro/src/controller/ui/register_page_controller.dart';

class RegisterStep1 extends StatelessWidget {
  const RegisterStep1({
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
          '이메일과 비밀번호를 입력해주세요',
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
                content: '이메일',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요';
                  } else if (!GetUtils.isEmail(value)) {
                    return '잘못된 이메일 형식입니다';
                  } else {
                    return null;
                  }
                },
                controller: RegisterPageController.to.emailEditingController,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                content: '비밀번호',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  } else if (GetUtils.isAlphabetOnly(value) ||
                      GetUtils.isNumericOnly(value) ||
                      value.length < 8 ||
                      value.length > 16) {
                    return '영문, 숫자 조합 8~16자리로 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller: RegisterPageController.to.passwordEditingController,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                content: '비밀번호 확인',
                validator: (value) {
                  if (RegisterPageController
                          .to.passwordEditingController.text !=
                      value) {
                    return '비밀번호가 일치하지 않습니다';
                  } else {
                    return null;
                  }
                },
                controller:
                    RegisterPageController.to.passwordConfirmEditingController,
                obscureText: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
