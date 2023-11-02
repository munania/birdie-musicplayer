import 'package:flutter/material.dart';
import 'package:musicplayer/homePage.dart';
import 'package:musicplayer/settings.dart';
import 'package:musicplayer/theme/theme_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'constants/colors.dart';
import 'musicList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

ThemeManager _themeManager = ThemeManager();

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  TabController? tabController;
  TextEditingController controller = TextEditingController();
  int selectTab = 0;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
    _themeManager.addListener(themeListener);

    tabController = TabController(length: 3, vsync: this);

    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeManager.addListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if(mounted) {
      setState(() {

      });
    }
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(value: _themeManager.themeMode == ThemeMode.dark, onChanged: (newValue) {
            _themeManager.toggleTheme(newValue);
          })
        ],
        backgroundColor: AppColor.bg,
        elevation: 0,
        title: Row(
          children: [
            const Text("Musically"),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xff292E4B),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 20),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        width: 30,
                        child: Image.asset(
                          "assets/images/search.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColor.primaryText28,
                        ),
                      ),
                      hintText: "Search album song",
                      hintStyle: TextStyle(
                        color: AppColor.primaryText28,
                        fontSize: 13,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget(): TabBarView(
          controller: tabController,
          children: const [
            HomePage(),
            MusicListScreen(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColor.bg, boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(0, -3),
          )
        ]),
        child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.transparent,
              indicatorWeight: 1,
              labelColor: AppColor.primary,
              labelStyle: const TextStyle(fontSize: 10),
              unselectedLabelColor: AppColor.primaryText28,
              unselectedLabelStyle: const TextStyle(fontSize: 10),
              tabs: [
                Tab(
                  text: "Home",
                  icon: Image.asset(
                    selectTab == 0
                        ? "assets/images/home_tab.png"
                        : "assets/images/home_tab_un.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                Tab(
                  text: "Songs",
                  icon: Image.asset(
                    selectTab == 1
                        ? "assets/images/songs_tab.png"
                        : "assets/images/songs_tab_un.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                Tab(
                  text: "Settings",
                  icon: Image.asset(
                    selectTab == 2
                        ? "assets/images/songs_tab.png"
                        : "assets/images/setting_tab_un.png",
                    width: 20,
                    height: 20,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("To play music give media access to the app"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

}
