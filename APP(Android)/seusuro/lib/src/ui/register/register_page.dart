import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/bottom_button.dart';
import 'package:seusuro/src/controller/ui/register_page_controller.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/main_page.dart';
import 'package:seusuro/src/ui/register/register_step_1.dart';
import 'package:seusuro/src/ui/register/register_step_2.dart';
import 'package:seusuro/src/ui/register/register_step_3.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterPageController());

    final formKey1 = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();
    final formKey3 = GlobalKey<FormState>();

    return rScaffold(
      rBody: Container(
        color: AppColors().bgWhite,
        child: Column(
          children: [
            Obx(() => LinearProgressIndicator(
                  value: RegisterPageController.to.registerStep.value / 3,
                  minHeight: 4,
                  color: AppColors().lineBlack,
                  backgroundColor: AppColors().lineGrey,
                )),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Obx(() {
                    switch (RegisterPageController.to.registerStep.value) {
                      case 1:
                        return RegisterStep1(formkey: formKey1);
                      case 2:
                        return RegisterStep2(formkey: formKey2);
                      case 3:
                        return RegisterStep3(formkey: formKey3);
                      default:
                        return Container();
                    }
                  }),
                ],
              ),
            ),
            Obx(() => BottomButton(
                  content: RegisterPageController.to.registerStep.value < 3
                      ? '다음'
                      : '시작하기',
                  onTap: () {
                    var formKey = GlobalKey<FormState>();

                    switch (RegisterPageController.to.registerStep.value) {
                      case 1:
                        formKey = formKey1;
                        break;
                      case 2:
                        formKey = formKey2;
                        break;
                      case 3:
                        formKey = formKey3;
                        break;
                    }

                    if (formKey.currentState!.validate()) {
                      if (RegisterPageController.to.registerStep.value < 3) {
                        RegisterPageController.to.registerStep.value += 1;
                      } else {
                        Get.offAll(() => const MainPage(),
                            transition: rTransition());
                      }
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
