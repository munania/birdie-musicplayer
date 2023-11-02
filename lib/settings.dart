import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'common_widgets/icon_text_row.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          IconTextRow(
            title: "Display",
            icon: "assets/images/s_display.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Audio",
            icon: "assets/images/s_audio.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Headset",
            icon: "assets/images/s_headset.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Lock Screen",
            icon: "assets/images/s_lock_screen.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Advanced",
            icon: "assets/images/s_menu.png",
            onTap: () {},
          ),
          IconTextRow(
            title: "Other",
            icon: "assets/images/s_other.png",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
