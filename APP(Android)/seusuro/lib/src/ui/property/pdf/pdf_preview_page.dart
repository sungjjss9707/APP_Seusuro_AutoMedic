import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/responsive_scaffold.dart';
import 'package:seusuro/src/ui/property/pdf/generate_document.dart';

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return rScaffold(
      rAppBar: _appBar(),
      rBody: Container(
        color: AppColors().bgWhite,
        child: const PdfPreview(
          build: generateDocument,
          canDebug: false,
          canChangePageFormat: false,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors().bgWhite,
      title: Text(
        'PDF 미리보기',
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
    );
  }
}
