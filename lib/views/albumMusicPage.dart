import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/theme/theme_constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/musicPlayerController.dart';

class AlbumMusicPage extends StatefulWidget {
  final int albumId;
  final String albumName;
  final String? albumArtistName;

  const AlbumMusicPage(
      {super.key,
      required this.albumId,
      required this.albumName,
      required this.albumArtistName});

  @override
  State<AlbumMusicPage> createState() => _AlbumMusicPageState();
}

class _AlbumMusicPageState extends State<AlbumMusicPage> {
  final MusicPlayerController _musicPlayerController = Get.find();

  List<SongModel> mp3Files = [];
  List<SongModel> songsInAlbum = [];

  TextEditingController playlistController = TextEditingController();

  bool isPlayerViewVisible = false;

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

    //   Update the currently playing song index listener
    _musicPlayerController.player.currentIndexStream.listen((index) {
      if (index != null) {
        updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumName),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<SongModel>>(
          future: _musicPlayerController.audioQuery.querySongs(
            sortType: SongSortType.ALBUM,
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

            print(
                "object-----------------------------------------------MP3\n\n $mp3Files");

            // Filter songs by album ID
            songsInAlbum = item.data!
                .where((song) => song.albumId == widget.albumId)
                .toList();

            return Column(
              children: [
                Container(
                  color: darkBackgroundColor,
                  height: 320,
                  width: 500,
                  child: Column(
                    children: [
                      FutureBuilder<Uint8List?>(
                        future: _musicPlayerController.audioQuery.queryArtwork(
                          widget.albumId,
                          ArtworkType.ALBUM,
                          format: ArtworkFormat.PNG,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                ),
                                height: 200,
                                width: 200,
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                ),
                                height: 200,
                                width: 200,
                                child: Image.asset(
                                  "assets/images/songs_tab.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                widget.albumName,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(widget.albumArtistName.toString()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  // color: Colors.blueGrey,
                  width: 500,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.shuffle,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.play_circle,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: ListView.builder(
                      itemCount: songsInAlbum.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              color: darkBackgroundColor,
                              child: ListTile(
                                title: Text(
                                  songsInAlbum[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  songsInAlbum[index].artist ?? "No artist",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                leading: FutureBuilder<Uint8List?>(
                                  future: _musicPlayerController.audioQuery
                                      .queryArtwork(
                                    songsInAlbum[index].id,
                                    ArtworkType.AUDIO,
                                    format: ArtworkFormat.JPEG,
                                    size: 200,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(snapshot.data!),
                                      );
                                    } else {
                                      return const CircleAvatar(
                                        child: Icon(
                                          Icons.music_note,
                                          color: darkTextColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                onTap: () async {
                                  // _changePlayerViewVisibility();
                                  Get.snackbar(
                                      "Playing", songsInAlbum[index].title,
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: darkTextColor,
                                      backgroundColor: darkBackgroundColor,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      instantInit: true,
                                      dismissDirection:
                                          DismissDirection.horizontal);

                                  await _musicPlayerController.player
                                      .setAudioSource(
                                          createPlaylist(songsInAlbum),
                                          initialIndex: index);
                                  await _musicPlayerController.player.play();
                                },
                                trailing: const InkWell(
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
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
    if (mounted) {
      setState(
        () {
          if (songsInAlbum.isNotEmpty) {
            _musicPlayerController.currentSongTitle.value =
                songsInAlbum[index].title;
            _musicPlayerController.currentIndex.value = index;
            _musicPlayerController.artistName.value =
                songsInAlbum[index].artist!;
          }
        },
      );
    }
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});

  Duration position, total;
}
