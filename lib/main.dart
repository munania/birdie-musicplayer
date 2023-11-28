import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controllers/musicPlayerController.dart';
import 'package:musicplayer/theme/theme_constants.dart';
import 'package:musicplayer/theme/theme_manager.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager1 = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Birdie Music Player',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager1.themeMode,
      home: const Home(),
      initialBinding: BindingsBuilder(() {
        Get.put(MusicPlayerController());
      }),
    );
  }
}

