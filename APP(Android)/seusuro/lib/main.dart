import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:seusuro/firebase_options.dart';
import 'package:seusuro/src/app_colors.dart';
import 'package:seusuro/src/app_scroll_behavior.dart';
import 'package:seusuro/src/controller/data_controller.dart';
import 'package:seusuro/src/ui/splash_page.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DataController());

    return GetMaterialApp(
      title: '스수로',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primaryColor: AppColors().keyBlue,
      ),
      home: const SplashPage(),
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
    );
  }
}
