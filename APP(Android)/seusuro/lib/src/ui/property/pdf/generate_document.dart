import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/controller/ui/property_page_controller.dart';

Future<Uint8List> generateDocument(PdfPageFormat format) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final fontBase =
      pw.Font.ttf(await rootBundle.load('fonts/Pretendard-Regular.ttf'));
  final fontBold =
      pw.Font.ttf(await rootBundle.load('fonts/Pretendard-Bold.ttf'));

  final appLogoImage = pw.MemoryImage(
    (await rootBundle.load('assets/seusuro_logo.png')).buffer.asUint8List(),
  );
  final teamLogoImage = pw.MemoryImage(
    (await rootBundle.load('assets/automedic_title.png')).buffer.asUint8List(),
  );

  var propertyList = PropertyPageController.to.pdfPropertyList;

  List<List<dynamic>> cellDataList = [
    ['No.', '품명', '유효기간', '수량(단위)', '비고'],
  ];

  for (int i = 0; i < propertyList.length; i++) {
    int amount = 0;

    var amountByPlace = propertyList[i].amountByPlace;

    for (var element in amountByPlace) {
      if (element['storagePlace'] ==
          PropertyPageController.to.pdfStoragePlace.value) {
        amount = element['amount'];
      }
    }

    cellDataList.add([
      (i + 1).toString(),
      propertyList[i].name,
      propertyList[i].expirationDate.substring(0, 10),
      '${amount.toString()} ${propertyList[i].unit}',
      _status(propertyList[i].expirationDate),
    ]);
  }

  doc.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fontBase,
        bold: fontBold,
      ),
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          child: pw.Row(
            children: [
              pw.Spacer(),
              pw.Text(
                '의무대를 위한 스마트한 수불 관리 앱, 스수로',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 12,
                ),
              ),
              pw.Image(
                appLogoImage,
                height: 16,
              ),
            ],
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Row(
            children: [
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 12,
                ),
              ),
              pw.Spacer(),
              pw.Text(
                'Powered by',
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 12,
                ),
              ),
              pw.Image(
                teamLogoImage,
                height: 24,
              ),
            ],
          ),
        );
      },
      build: (pw.Context context) => [
        pw.Header(
          margin:
              const pw.EdgeInsets.symmetric(vertical: 1.0 * PdfPageFormat.cm),
          child: pw.Row(
            children: [
              pw.Text(
                '${DataController.to.userInfo.value!.militaryUnit} 의무대 ${PropertyPageController.to.pdfStoragePlace}',
                textScaleFactor: 2,
              ),
              pw.Spacer(),
              pw.Text(
                DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
                textScaleFactor: 1,
              ),
            ],
          ),
        ),
        pw.Table.fromTextArray(
          context: context,
          cellAlignment: pw.Alignment.center,
          data: cellDataList,
        ),
      ],
    ),
  );

  return await doc.save();
}

String _status(String sExpirationDate) {
  var status = '';

  DateTime expirationDate =
      DateFormat('yyyy-MM-dd hh:mm:ss').parse(sExpirationDate);

  if (expirationDate.difference(DateTime.now()) > const Duration(days: 365)) {
    status = '양호';
  } else if (expirationDate.difference(DateTime.now()) >
      const Duration(days: 180)) {
    status = '주의';
  } else {
    status = '경고';
  }

  return status;
}
