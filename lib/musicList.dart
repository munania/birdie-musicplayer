import 'dart:typed_data';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/playlist/addSongToPlaylist.dart';
import 'package:musicplayer/playlist/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'constants/colors.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  MusicListScreenState createState() => MusicListScreenState();
}

class MusicListScreenState extends State<MusicListScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
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

  // Player
  final AudioPlayer _player = AudioPlayer();

  // Duration state stream
  Stream<DurationState> get _durationStateStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream,
          _player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();

    //   Update the currently playing song index listener
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerViewVisible) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
            decoration: BoxDecoration(color: AppColor.bg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _changePlayerViewVisibility();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColor.primaryText,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Now Playing",
                          style: TextStyle(
                            color: AppColor.primaryText,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //artwork container
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryText.withOpacity(0.3),
                        // Color of the shadow
                        spreadRadius: 0.1,
                        // Spread radius of the shadow
                        blurRadius: 10000,
                        // Blur radius of the shadow
                        offset: const Offset(0, 20), // Offset of the shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 60, bottom: 30),
                  child: QueryArtworkWidget(
                    id: mp3Files[currentIndex].id,
                    artworkQuality: FilterQuality.high,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(20.0),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          currentSongTitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 120,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //go to playlist btn
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _changePlayerViewVisibility();
                        },
                        child: Icon(
                          Icons.list_alt,
                          size: 30,
                          color: AppColor.primaryText,
                        ),
                      ),
                    ),

                    //Favorite song button
                    Flexible(
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.heart_broken_outlined,
                          size: 30,
                          color: AppColor.primaryText,
                        ),
                      ),
                    ),

                    //Add to playlist btn
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          List<Playlist> playlists = [];
                          print(mp3Files[currentIndex].id);
                          Get.defaultDialog(
                            title: "Create a new playlist",
                            titleStyle: TextStyle(color: AppColor.primaryText),
                            backgroundColor: AppColor.bg,
                            content: Column(
                              children: [
                                TextField(
                                  controller: playlistController,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1, color: AppColor.primaryText,
                                      )
                                    )
                                  ),
                                ),
                                ElevatedButton(onPressed: () {
                                  int id = mp3Files[currentIndex].id;
                                  Get.to(AddSongToPlaylist(id: id, playlistName: playlistController.text));
                                }, child: const Text("Create"))
                              ],
                            )
                          );
                        },
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: AppColor.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 40,
                ),

                //slider , position and duration widgets
                Column(
                  children: [
                    //slider bar container
                    Container(
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.only(bottom: 4.0),

                      //slider bar duration state stream
                      child: StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final progress =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return ProgressBar(
                            progress: progress,
                            total: total,
                            barHeight: 5.0,
                            baseBarColor: AppColor.primaryText28,
                            progressBarColor: AppColor.focus,
                            thumbColor: AppColor.secondaryEnd,
                            timeLabelTextStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            onSeek: (duration) {
                              _player.seek(duration);
                            },
                          );
                        },
                      ),
                    ),

                    //position /progress and total text
                    StreamBuilder<DurationState>(
                      stream: _durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Text(
                                progress.toString().split(".")[0],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                total.toString().split(".")[0],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(
                  height: 40,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //shuffle playlist
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          _player.setShuffleModeEnabled(true);
                          Get.snackbar("", "Shuffling Enabled",
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: AppColor.focus,
                              backgroundColor: AppColor.bg,
                              duration: const Duration(milliseconds: 1500),
                              instantInit: true,
                              dismissDirection: DismissDirection.horizontal);
                        },
                        child: Icon(
                          Icons.shuffle,
                          size: 30,
                          color:
                              isClicked ? AppColor.focus : AppColor.primaryText,
                        ),
                      ),
                    ),

                    //skip to previous
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.hasPrevious) {
                            _player.seekToPrevious();
                          }
                        },
                        child: Icon(
                          Icons.skip_previous,
                          size: 30,
                          color: AppColor.primaryText,
                        ),
                      ),
                    ),

                    //play pause
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.playing) {
                            _player.pause();
                          } else {
                            if (_player.currentIndex != null) {
                              _player.play();
                            }
                          }
                        },
                        child: StreamBuilder<bool>(
                          stream: _player.playingStream,
                          builder: (context, snapshot) {
                            bool? playingState = snapshot.data;
                            if (playingState != null && playingState) {
                              return Icon(
                                Icons.pause,
                                size: 30,
                                color: AppColor.primaryText,
                              );
                            }
                            return Icon(
                              Icons.play_arrow,
                              size: 30,
                              color: AppColor.primaryText,
                            );
                          },
                        ),
                      ),
                    ),

                    //skip to next
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (_player.hasNext) {
                            _player.seekToNext();
                          }
                        },
                        child: Icon(
                          Icons.skip_next,
                          color: AppColor.primaryText,
                          size: 30,
                        ),
                      ),
                    ),

                    //repeat mode
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _player.loopMode == LoopMode.one
                              ? _player.setLoopMode(LoopMode.all)
                              : _player.setLoopMode(LoopMode.one);
                        },
                        child: StreamBuilder<LoopMode>(
                          stream: _player.loopModeStream,
                          builder: (context, snapshot) {
                            final loopMode = snapshot.data;
                            if (LoopMode.one == loopMode) {
                              return Icon(
                                Icons.repeat_one,
                                size: 30,
                                color: AppColor.focus,
                              );
                            }
                            return Icon(
                              Icons.repeat,
                              size: 30,
                              color: AppColor.primaryText,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: SongSortType.DATE_ADDED,
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
              return ListView.builder(
                  itemCount: item.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.only(bottom: 5.0),
                          color: AppColor.bg,
                          child: ListTile(
                            title: Text(
                              item.data![index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15),
                            ),
                            subtitle: Text(
                              item.data![index].artist ?? "No artist",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15),
                            ),
                            leading: FutureBuilder<Uint8List?>(
                                future: _audioQuery.queryArtwork(
                                  item.data![index].id,
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
                                    return CircleAvatar(
                                      child: Icon(
                                        Icons.music_note,
                                        color: AppColor.primaryText80,
                                      ),
                                    );
                                  }
                                }),
                            onTap: () async {
                              _changePlayerViewVisibility();
                              Get.snackbar("Playing", item.data![index].title,
                                  snackPosition: SnackPosition.BOTTOM,
                                  colorText: AppColor.primaryText80,
                                  backgroundColor: AppColor.bg,
                                  duration: const Duration(milliseconds: 1500),
                                  instantInit: true,
                                  dismissDirection:
                                      DismissDirection.horizontal);
                              if (kDebugMode) {
                                print(item.data!);
                              }

                              await _player.setAudioSource(
                                  createPlaylist(item.data),
                                  initialIndex: index);
                              await _player.play();
                            },
                          ),
                        ),
                      ],
                    );
                  });
            }),
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

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: AppColor.primaryText,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

  BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset,
      double blurRadius, double spreadRadius) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: AppColor.primaryText,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});

  Duration position, total;
}
