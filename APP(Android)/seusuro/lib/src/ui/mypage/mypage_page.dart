import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/custom_alert_dialog.dart';
import 'package:seusuro/src/component/list_tile_button.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/mypage_page_controller.dart';
import 'package:seusuro/src/responsive_snackbar.dart';
import 'package:seusuro/src/responsive_transition.dart';
import 'package:seusuro/src/ui/login_page.dart';
import 'package:seusuro/src/ui/mypage/edit_profile_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MypagePage extends StatelessWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MypagePageController());

    return Container(
      color: AppColors().bgWhite,
      child: ListView(
        shrinkWrap: true,
        children: [
          _userProfile(),
          Container(
            height: 4,
            color: AppColors().lineGrey,
          ),
          _appSettings(),
          Container(
            height: 4,
            color: AppColors().lineGrey,
          ),
          _appInformation(context),
        ],
      ),
    );
  }

  Widget _userProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: [
          Obx(() => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: AppColors().keyGrey,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: DataController.to.userInfo.value!.pictureName.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        size: 80,
                        color: AppColors().keyGrey,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ImageNetwork(
                          width: 100,
                          height: 100,
                          image: DataController.to.userInfo.value!.pictureName,
                          onLoading: CircularProgressIndicator(
                            color: AppColors().keyGrey,
                          ),
                        ),
                      ),
              )),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    '${DataController.to.userInfo.value!.rank} ${DataController.to.userInfo.value!.name}',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              const SizedBox(height: 12),
              Text(
                DataController.to.userInfo.value!.serviceNumber,
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DataController.to.userInfo.value!.militaryUnit,
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              MypagePageController.to.resetInputs();

              Get.dialog(const EditProfileDialog());
            },
            child: const Icon(Icons.edit_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _appSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            '설정',
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListTileButton(
          content: '의무대 재산 DB 업로드',
          onTap: () {
            rSnackbar(title: '알림', message: '아직 준비 중인 기능입니다 :)');
          },
        ),
        ListTileButton(
          content: '로그아웃',
          showIcon: false,
          onTap: () {
            Get.dialog(
              CustomAlertDialog(
                message: '정말 로그아웃 하시겠습니까?',
                onConfirm: () {
                  DataController.to.logout();

                  Get.offAll(() => const LoginPage(),
                      transition: rTransition());
                },
              ),
            );
          },
        ),
        ListTileButton(
          content: '회원탈퇴',
          showIcon: false,
          textColor: AppColors().textRed,
          onTap: () {
            Get.dialog(
              CustomAlertDialog(
                message: '정말 회원탈퇴 하시겠습니까?',
                textColor: AppColors().textRed,
                onConfirm: () async {
                  if (await MypagePageController.to.withdrawal()) {
                    DataController.to.logout();

                    Get.offAll(() => const LoginPage(),
                        transition: rTransition());
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _appInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            '정보',
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ListTileButton(
          content: 'Team AutoMedic',
          onTap: () {
            rSnackbar(title: '알림', message: '아직 준비 중인 기능입니다 :)');
          },
        ),
        ListTileButton(
          content: 'GitHub 저장소',
          onTap: () async {
            final Uri url = Uri.parse(
              'https://github.com/osamhack2022/APP_Seusuro_AutoMedic',
            );

            if (!await launchUrl(url)) {
              throw 'Could not launch $url';
            }
          },
        ),
        ListTileButton(
          content: '팀 노션 페이지',
          onTap: () async {
            final Uri url = Uri.parse(
              'https://medtopublic.notion.site/fd0ad5a638504e9c9cdabdb736e48a7e',
            );

            if (!await launchUrl(url)) {
              throw 'Could not launch $url';
            }
          },
        ),
        ListTileButton(
          content: '오픈 소스 라이선스',
          onTap: () {
            showLicensePage(
              context: context,
              applicationIcon: Image.asset('assets/seusuro_logo.png'),
              applicationName: '스마트 수불 로그',
              applicationVersion: 'ver 1.0.0',
            );
          },
        ),
      ],
    );
  }
}
