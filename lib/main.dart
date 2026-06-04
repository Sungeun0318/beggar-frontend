import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:beggar_app/core/theme/app_colors.dart';
import 'package:beggar_app/core/config/api_config.dart';
import 'package:beggar_app/prototype_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final kakaoNativeAppKey = await ApiConfig.kakaoNativeAppKey();
  if (kakaoNativeAppKey.isNotEmpty) {
    await KakaoSdk.init(
      nativeAppKey: kakaoNativeAppKey,
      loggingEnabled: true,
    );
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.bg,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const BeggarPrototypeApp());
}

class BeggarPrototypeApp extends StatelessWidget {
  const BeggarPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '거지 우정 수호대',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Pretendard',
        textTheme: Typography.blackCupertino.apply(
          bodyColor: AppColors.text,
          displayColor: AppColors.text,
          fontFamily: 'Pretendard',
        ),
      ),
      home: const PrototypeShell(),
    );
  }
}
