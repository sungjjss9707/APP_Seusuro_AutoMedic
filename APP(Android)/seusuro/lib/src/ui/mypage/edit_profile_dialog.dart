import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/mypage_page_controller.dart';
import 'package:seusuro/src/model/user_info.dart';
import 'package:seusuro/src/responsive_bottom_sheet.dart';

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var isDesktop = DataController.to.isDesktop();

    var mobileWidth = DataController.to.mobileWidth;
    var screenWidth = DataController.to.screenWidth.value;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? mobileWidth : screenWidth,
        margin: EdgeInsets.only(
          left: screenWidth > mobileWidth + 480 ? 480 : 0,
        ),
        padding: const EdgeInsets.all(32),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors().bgWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '프로필 수정',
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        child: Obx(() => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors().keyGrey,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: MypagePageController
                                      .to.imageAsBytes.value.isEmpty
                                  ? MypagePageController
                                          .to.imagePath.value.isEmpty
                                      ? Icon(
                                          Icons.person_rounded,
                                          size: 80,
                                          color: AppColors().keyGrey,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: ImageNetwork(
                                            width: 100,
                                            height: 100,
                                            image: DataController
                                                .to.userInfo.value!.pictureName,
                                            onTap: _pickImage,
                                            onLoading:
                                                CircularProgressIndicator(
                                              color: AppColors().keyGrey,
                                            ),
                                          ),
                                        )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        MypagePageController
                                            .to.imageAsBytes.value,
                                      ),
                                    ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 64, top: 64),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors().lineGrey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.photo_camera_rounded,
                            color: AppColors().bgBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _inputName(),
                  const SizedBox(height: 16),
                  _inputEmail(),
                  const SizedBox(height: 16),
                  _inputPhoneNumber(),
                  const SizedBox(height: 16),
                  _inputRank(),
                  const SizedBox(height: 16),
                  _inputEnlistmentDate(),
                  const SizedBox(height: 16),
                  _inputDischargeDate(),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      if (await MypagePageController.to.uploadImage()) {
                        var oldUserInfo = DataController.to.userInfo.value;

                        var newUserInfo = UserInfo(
                          oldUserInfo!.id,
                          MypagePageController.to.nameEditingController.text,
                          MypagePageController.to.emailEditingController.text,
                          MypagePageController
                              .to.phoneNumberEditingController.text,
                          oldUserInfo.serviceNumber,
                          MypagePageController.to.rank.value,
                          MypagePageController.to.enlistmentDate.toString(),
                          MypagePageController.to.dischargeDate.toString(),
                          oldUserInfo.militaryUnit,
                          MypagePageController.to.imagePath.value,
                          oldUserInfo.createdAt,
                          oldUserInfo.updatedAt,
                        );

                        await MypagePageController.to.editProfile(newUserInfo);
                      }
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: AppColors().textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageAsBytes = await image.readAsBytes();
      MypagePageController.to.imageAsBytes.value = imageAsBytes;
    }
  }

  Widget _inputName() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '이름',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: MypagePageController.to.nameEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '이름을 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputEmail() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '이메일',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: MypagePageController.to.emailEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '이메일을 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputPhoneNumber() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '전화번호',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: MypagePageController.to.phoneNumberEditingController,
            style: TextStyle(
              color: AppColors().textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: AppColors().bgBlack,
            decoration: InputDecoration(
              hintText: '전화번호를 입력하세요',
              hintStyle: TextStyle(
                color: AppColors().textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputRank() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '계급',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Get.bottomSheet(_rankBottomSheet());
            },
            child: Obx(() => Text(
                  MypagePageController.to.rank.value.isEmpty
                      ? '계급을 입력하세요'
                      : MypagePageController.to.rank.value,
                  style: TextStyle(
                    color: MypagePageController.to.rank.value.isEmpty
                        ? AppColors().textGrey
                        : AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget _rankBottomSheet() {
    var rankList = MypagePageController.to.rankList;

    return rBottomSheet(
      height: 240,
      color: AppColors().bgWhite,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors().lineGrey,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 196,
            child: CupertinoPicker(
              itemExtent: 48,
              magnification: 1.2,
              scrollController: FixedExtentScrollController(initialItem: 6),
              onSelectedItemChanged: (int index) {
                MypagePageController.to.rank.value = rankList[index];
              },
              children: List.generate(rankList.length, (int index) {
                return Center(
                  child: Text(
                    rankList[index],
                    style: TextStyle(
                      color: AppColors().textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputEnlistmentDate() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '입대일',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var enlistmentDate = await _showDatePicker(Get.overlayContext!);

              if (enlistmentDate != null) {
                MypagePageController.to.enlistmentDate.value = enlistmentDate;
              }
            },
            child: Obx(() => Text(
                  MypagePageController.to.enlistmentDate.value ==
                          DateTime(2000, 1, 1)
                      ? '입대일을 입력하세요'
                      : DateFormat('yyyy년 MM월 dd일')
                          .format(MypagePageController.to.enlistmentDate.value),
                  style: TextStyle(
                    color: MypagePageController.to.enlistmentDate.value ==
                            DateTime(2000, 1, 1)
                        ? AppColors().textGrey
                        : AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget _inputDischargeDate() {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '입대일',
            style: TextStyle(
              color: AppColors().textLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              var dischargeDate = await _showDatePicker(Get.overlayContext!);

              if (dischargeDate != null) {
                MypagePageController.to.dischargeDate.value = dischargeDate;
              }
            },
            child: Obx(() => Text(
                  MypagePageController.to.dischargeDate.value ==
                          DateTime(2000, 1, 1)
                      ? '입대일을 입력하세요'
                      : DateFormat('yyyy년 MM월 dd일')
                          .format(MypagePageController.to.dischargeDate.value),
                  style: TextStyle(
                    color: MypagePageController.to.dischargeDate.value ==
                            DateTime(2000, 1, 1)
                        ? AppColors().textGrey
                        : AppColors().textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors().keyBlue,
              onPrimary: AppColors().textWhite,
              onSurface: AppColors().textBlack,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
