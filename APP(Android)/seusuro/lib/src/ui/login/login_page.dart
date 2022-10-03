import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/login_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/login/custom_text_form_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginPageController());

    final formKey = GlobalKey<FormState>();

    return rScaffold(
      rBody: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors().keyRed,
              AppColors().keyBlue,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors().bgWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appLogo(),
              const SizedBox(height: 60),
              _userInputs(formKey),
              const SizedBox(height: 48),
              _loginButton(formKey),
              const SizedBox(height: 16),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/seusuro_logo.png',
          width: 120,
          height: 120,
        ),
        const SizedBox(height: 4),
        Text(
          '스수로',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _userInputs(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
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
            controller: LoginPageController.to.emailEditingController,
          ),
          const SizedBox(height: 24),
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
            controller: LoginPageController.to.passwordEditingController,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _loginButton(GlobalKey<FormState> formKey) {
    return InkWell(
      onTap: () {
        // 로그인 버튼
        formKey.currentState?.validate();
      },
      child: Container(
        width: 150,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors().bgBlack,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          '로그인',
          style: TextStyle(
            color: AppColors().textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {
        // 회원가입 버튼
      },
      child: Text(
        '회원가입',
        style: TextStyle(
          color: AppColors().textGrey,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
