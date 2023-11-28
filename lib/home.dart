import 'package:flutter/material.dart';
import 'package:musicplayer/views/albumsView.dart';
import 'package:musicplayer/views/allSongsView.dart';
import 'package:musicplayer/views/artistsView.dart';
import 'package:musicplayer/views/foldersView.dart';
import 'package:musicplayer/views/playListsView.dart';
import 'package:musicplayer/widgets/bottomAppbar.dart';
import 'package:on_audio_query/on_audio_query.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


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

    tabController = TabController(length: 6, vsync: this);
    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });
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
        elevation: 0,
        title: Row(
          children: [
            Text("Birdie", style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                ),
                child: TextField(
                  // controller: controller,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      width: 30,
                      child: Image.asset(
                        "assets/images/search.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    hintText: "Search album song",
                    hintStyle:
                        Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight - 15,
            child: TabBar(
              controller: tabController,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              isScrollable: true,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(
                  text: "All Songs",
                ),
                Tab(
                  text: "Playlists",
                ),
                Tab(
                  text: "Albums",
                ),
                Tab(
                  text: "Artists",
                ),
                Tab(
                  text: "Genres",
                ),
                Tab(
                  text: "Folders",
                ),
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: const [
              AllSongsView(),
              PlayListsView(),
              AlbumsView(),
              ArtistsView(),
              FoldersView(),
              FoldersView(),
            ],
          ))
        ],
      ),
      bottomNavigationBar: const BottomBar(),
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
