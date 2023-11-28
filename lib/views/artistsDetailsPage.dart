
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/musicPlayerController.dart';
import '../theme/theme_constants.dart';

class ArtistDetailPage extends StatefulWidget {
  final int artistId;
  final String artistName;

  const ArtistDetailPage(
      {super.key, required this.artistId, required this.artistName});

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage>
    with SingleTickerProviderStateMixin {
  final MusicPlayerController _musicPlayerController = Get.find();

  TabController? tabController;
  TextEditingController controller = TextEditingController();
  int selectTab = 0;

  List<SongModel> mp3Files = [];
  int currentIndex = 0;
  String currentSongTitle = "";

  TextEditingController playlistController = TextEditingController();

  bool isPlayerViewVisible = false;

  bool isClicked = false;

  void toggleClick() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  // Player view visibility
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  // Duration state stream
  // Stream<DurationState> get _durationStateStream =>
  //     rxdart.Rx.combineLatest2<Duration, Duration?, DurationState>(
  //         _musicPlayerController.player.positionStream,
  //         _musicPlayerController.player.durationStream,
  //         (position, duration) => DurationState(
  //             position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });

    //   Update the currently playing song index listener
    _musicPlayerController.player.currentIndexStream.listen((index) {
      if (index != null) {
        updateCurrentPlayingSongDetails(index);
      }
    });
  }

  // @override
  // void dispose() {
  //   _musicPlayerController.player.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artistName),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<SongModel>>(
          future: _musicPlayerController.audioQuery.querySongs(
            sortType: SongSortType.ARTIST,
            orderType: OrderType.DESC_OR_GREATER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.hasError) {
              return Text(item.error.toString());
            }
            //   Waiting for content
            if (item.data == null) {
              return const CircularProgressIndicator();
            }
            //   Empty library
            if (item.data!.isEmpty) {
              return const Text("No music found");
            }
            mp3Files.clear();
            mp3Files = item.data!;

            // print(item.data!);

            // Filter songs by album ID
            List<SongModel> songsUnderArtist = item.data!
                .where((song) => song.artistId == widget.artistId)
                .toList();

            print("'''''''''''''''''''''''");
            print(songsUnderArtist);

            return ListView.builder(
              itemCount: songsUnderArtist.length,
              itemBuilder: (context, index) {
                
                int? duration =  songsUnderArtist[index].duration;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 5.0, top: 20),
                  color: darkBackgroundColor,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      clipBehavior: Clip.antiAlias,
                      child: const SizedBox(
                        width: 70,
                        height: 70,
                        child: Icon(Icons.add),
                      ),
                    ),
                    title: Text(songsUnderArtist[index].title),
                    trailing: Text(duration.toString()),
                    onTap: () async {
                      _changePlayerViewVisibility();
                      Get.snackbar(
                          "Playing", songsUnderArtist[index].title,
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: darkTextColor,
                          backgroundColor: darkBackgroundColor,
                          duration:
                          const Duration(milliseconds: 1500),
                          instantInit: true,
                          dismissDirection:
                          DismissDirection.horizontal);

                      await _musicPlayerController.player.setAudioSource(
                          createPlaylist(songsUnderArtist),
                          initialIndex: index);
                      await _musicPlayerController.player.play();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel>? songs) {
    List<AudioSource> sources = [];

    for (var song in songs!) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (mp3Files.isNotEmpty) {
        currentSongTitle = mp3Files[index].title;
        currentIndex = index;
      }
    });
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});

  Duration position, total;
}
