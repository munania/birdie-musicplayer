import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/theme/theme_constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/musicPlayerController.dart';
import 'PlaylistDetailPage.dart';

class PlayListsView extends StatefulWidget {
  const PlayListsView({super.key});

  @override
  State<PlayListsView> createState() => _PlayListsViewState();
}

class _PlayListsViewState extends State<PlayListsView> {
  final MusicPlayerController _musicPlayerController = Get.find();


  TextEditingController playlistController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: (){
                    Get.defaultDialog(
                        title: "Enter playlist name",
                        content: Column(
                          children: [
                            TextField(
                              controller: playlistController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1, color: darkSecondaryTextColor,
                                      )
                                  )
                              ),
                            ),
                            ElevatedButton(onPressed: () {
                              _musicPlayerController.audioQuery.createPlaylist(playlistController.text);
                              playlistController.clear();
                              Get.back();
                              setState(() { });
                            }, child: const Text("create"))
                          ],
                        )
                    );
                  },
                    child:const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 20,),
                        Text("Create Playlist"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PlaylistModel>>(
                  future: _musicPlayerController.audioQuery.queryPlaylists(
                    sortType: PlaylistSortType.DATE_ADDED,
                    orderType: OrderType.DESC_OR_GREATER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true,
                  ),
                  builder: (context, snapshot) {
                    if (kDebugMode) {
                      print(snapshot.data);
                    }

                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    //   Waiting for content
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    //   Empty library
                    if (snapshot.data!.isEmpty) {
                      return const Text("No Albums found");
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String artistName = snapshot.data![index].playlist;
                        int numberOfTracksInPlaylist =
                            snapshot.data![index].numOfSongs;
                        int playlistId = snapshot.data![index].id;
                        String playlistString = snapshot.data![index].playlist;

                        return FutureBuilder<Uint8List?>(
                          future: _musicPlayerController.audioQuery.queryArtwork(
                            snapshot.data![index].id,
                            ArtworkType.PLAYLIST,
                            format: ArtworkFormat.PNG,
                          ),
                          builder: (context, artworkSnapshot) {
                            if (artworkSnapshot.hasData &&
                                artworkSnapshot.data != null) {
                              return FutureBuilder<List<AlbumModel>>(
                                future: _musicPlayerController.audioQuery.queryAlbums(
                                  orderType: OrderType.DESC_OR_GREATER,
                                  sortType: AlbumSortType.ARTIST,
                                  ignoreCase: true,
                                ),
                                builder: (context, albumSnapshot) {
                                  return ListTile(
                                    onTap: () {
                                      Get.to(PlaylistDetailPage(
                                        playlistId: playlistId,
                                        playlistString: playlistString,
                                      ));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      clipBehavior: Clip.antiAlias,
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.memory(
                                          artworkSnapshot.data!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      artistName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    trailing: Text(
                                        "$numberOfTracksInPlaylist ${numberOfTracksInPlaylist > 1 ? 'tracks' : 'track'}"),
                                  );
                                },
                              );
                            } else {
                              return ListTile(
                                onTap: () {
                                  Get.to(PlaylistDetailPage(
                                    playlistId: playlistId,
                                    playlistString: playlistString,
                                  ));
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                      "assets/images/songs_tab.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  artistName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                trailing: Text(
                                    "$numberOfTracksInPlaylist ${numberOfTracksInPlaylist > 1 ? 'tracks' : 'track'}"),
                              );
                            }
                          },
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
