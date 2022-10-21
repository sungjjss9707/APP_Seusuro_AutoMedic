import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:image_network/image_network.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/model/drug_info.dart';
import 'package:seusuro/src/responsive_scaffold.dart';

class DrugInfoPage extends StatelessWidget {
  const DrugInfoPage({required this.drugInfo, super.key});

  final DrugInfo drugInfo;

  @override
  Widget build(BuildContext context) {
    Map drugDetailMap = _drugDetailMap();

    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(32),
          children: [
            _drugImage(),
            const SizedBox(height: 48),
            _basicInfo(),
            const SizedBox(height: 48),
            ListView.separated(
              shrinkWrap: true,
              itemCount: drugDetailMap.length,
              itemBuilder: (context, index) {
                var qesitm = drugDetailMap.keys.toList()[index];

                var content = parse(drugDetailMap[qesitm]);
                var parsedContent =
                    parse(content.body!.text).documentElement!.text;

                return _drugDetailTile(
                  question: qesitm,
                  answer: parsedContent,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 48),
            ),
          ],
        ),
      ),
    );
  }

  Map _drugDetailMap() {
    var drugDetailMap = {};

    if (drugInfo.efcyQesitm != null) {
      drugDetailMap['효능'] = drugInfo.efcyQesitm;
    }
    if (drugInfo.useMethodQesitm != null) {
      drugDetailMap['사용법'] = drugInfo.useMethodQesitm;
    }
    if (drugInfo.atpnWarnQesitm != null) {
      drugDetailMap['경고사항'] = drugInfo.atpnWarnQesitm;
    }
    if (drugInfo.atpnQesitm != null) {
      drugDetailMap['주의사항'] = drugInfo.atpnQesitm;
    }
    if (drugInfo.intrcQesitm != null) {
      drugDetailMap['상호작용'] = drugInfo.intrcQesitm;
    }
    if (drugInfo.seQesitm != null) {
      drugDetailMap['부작용'] = drugInfo.seQesitm;
    }
    if (drugInfo.depositMethodQesitm != null) {
      drugDetailMap['보관법'] = drugInfo.depositMethodQesitm;
    }

    return drugDetailMap;
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        '약품 정보',
        style: TextStyle(
          color: AppColors().textBlack,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: Get.back,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors().bgBlack,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // 북마크 추가/삭제하기
          },
          icon: Icon(
            Icons.bookmark_outline_rounded,
            color: AppColors().bgBlack,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _drugImage() {
    if (drugInfo.itemImage == null) {
      return Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors().lineGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.medication_rounded,
            size: 48,
            color: AppColors().bgWhite,
          ),
        ),
      );
    } else {
      return ImageNetwork(
        width: DataController.to.isDesktop() ? 296 : Get.width - 64,
        height: 120,
        image: drugInfo.itemImage!,
        onLoading: CircularProgressIndicator(
          color: AppColors().keyGrey,
        ),
        borderRadius: BorderRadius.circular(20),
      );
    }
  }

  Widget _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보',
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제품명',
              style: TextStyle(
                color: AppColors().textLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                drugInfo.itemName!,
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '업체명',
              style: TextStyle(
                color: AppColors().textLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                drugInfo.entpName!,
                style: TextStyle(
                  color: AppColors().textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _drugDetailTile({
    required String question,
    required String answer,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          answer,
          style: TextStyle(
            color: AppColors().textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
