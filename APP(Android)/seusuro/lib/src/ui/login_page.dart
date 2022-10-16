import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/ui/login_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/component/custom_text_form_field.dart';
import 'package:seusuro/src/ui/main_page.dart';
import 'package:seusuro/src/ui/register/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginPageController());

    final formKey = GlobalKey<FormState>();

    return rScaffold(
      rBody: Container(
        color: AppColors().bgWhite,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
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
    );
  }

  Widget _appLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/seusuro_logo.png',
            width: 110,
            height: 110,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Column(
            children: [
              Text(
                '스수로',
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 60,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '스마트 수불 로그',
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userInputs(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
            const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _loginButton(GlobalKey<FormState> formKey) {
    return InkWell(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          if (await LoginPageController.to.login()) {
            Get.off(() => const MainPage(), transition: rTransition());
          }
        }
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors().keyRed,
              AppColors().keyBlue,
            ],
          ),
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
        Get.to(() => const RegisterPage(), transition: rTransition());
      },
      child: Text(
        '회원가입',
        style: TextStyle(
          color: AppColors().textGrey,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
