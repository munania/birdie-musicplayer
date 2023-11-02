import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:musicplayer/playlist/playlist.dart';
import 'package:musicplayer/theme/theme_constants.dart';
import 'package:musicplayer/theme/theme_manager.dart';
import 'constants/colors.dart';
import 'home.dart';
import 'musicList.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      // theme: ThemeData(
      //   fontFamily: "Circular Std",
      //   scaffoldBackgroundColor: AppColor.bg,
      //   textTheme: Theme.of(context).textTheme.apply(
      //     bodyColor: AppColor.primaryText,
      //     displayColor: AppColor.primaryText,
      //   ),
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: AppColor.primary,
      //   ),
      //   useMaterial3: false,
      // ),
      home: const Home(),
    );
  }
}

