import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/component/custom_input_button.dart';
import 'package:seusuro/src/component/custom_text_form_field.dart';
import 'package:seusuro/src/controller/ui/register_page_controller.dart';
import 'package:seusuro/src/responsive_bottom_sheet.dart';

class RegisterStep2 extends StatelessWidget {
  const RegisterStep2({
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
          '사용자 정보를 알려주세요',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 64),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();

                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  Uint8List imageAsBytes = await image.readAsBytes();
                  RegisterPageController.to.imageAsBytes.value = imageAsBytes;
                }
              },
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
                    child: RegisterPageController.to.imageAsBytes.value.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            size: 80,
                            color: AppColors().keyGrey,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(
                              RegisterPageController.to.imageAsBytes.value,
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
        Form(
          key: formkey,
          child: Column(
            children: [
              CustomTextFormField(
                content: '이름',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller: RegisterPageController.to.nameEditingController,
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                content: '군번',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '군번을 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller:
                    RegisterPageController.to.serviceNumberEditingController,
              ),
              const SizedBox(height: 32),
              Obx(() => CustomInputButton(
                  content: '계급',
                  buttonText: RegisterPageController.to.rank.value,
                  onTap: () {
                    Get.bottomSheet(_rankBottomSheet());
                  })),
              const SizedBox(height: 32),
              Row(
                children: [
                  Flexible(
                    child: Obx(() => CustomInputButton(
                          content: '입대일',
                          buttonText:
                              RegisterPageController.to.enlistmentDate.value ==
                                      DateTime(2000, 1, 1)
                                  ? ''
                                  : DateFormat('yy년 MM월 dd일').format(
                                      RegisterPageController
                                          .to.enlistmentDate.value),
                          onTap: () async {
                            var enlistmentDate = await _showDatePicker(context);

                            if (enlistmentDate != null) {
                              RegisterPageController.to.enlistmentDate.value =
                                  enlistmentDate;
                            }
                          },
                        )),
                  ),
                  const SizedBox(width: 32),
                  Flexible(
                    child: Obx(() => CustomInputButton(
                          content: '전역일',
                          buttonText:
                              RegisterPageController.to.dischargeDate.value ==
                                      DateTime(2000, 1, 1)
                                  ? ''
                                  : DateFormat('yy년 MM월 dd일').format(
                                      RegisterPageController
                                          .to.dischargeDate.value),
                          onTap: () async {
                            var dischargeDate = await _showDatePicker(context);

                            if (dischargeDate != null) {
                              RegisterPageController.to.dischargeDate.value =
                                  dischargeDate;
                            }
                          },
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextFormField(
                content: '전화번호',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해주세요';
                  } else {
                    return null;
                  }
                },
                controller:
                    RegisterPageController.to.phoneNumberEditingController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rankBottomSheet() {
    var rankList = RegisterPageController.to.rankList;

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
                RegisterPageController.to.rank.value = rankList[index];
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

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 3, 21),
      lastDate: DateTime(2030, 12, 31),
    );
  }
}
