import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/musicPlayerController.dart';
import 'albumMusicPage.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({super.key});

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  final MusicPlayerController _musicPlayerController = Get.find();
  List<AlbumModel> albums = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<AlbumModel>>(
          future: _musicPlayerController.audioQuery.queryAlbums(
            orderType: OrderType.DESC_OR_GREATER,
            sortType: AlbumSortType.ARTIST,
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

            return ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              clipBehavior: Clip.antiAlias,
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                // clipBehavior: Clip.antiAlias,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  mainAxisExtent: 250,
                ),
                primary: false,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  var albumName = snapshot.data![index].album;
                  var numOfTracks = snapshot.data![index].numOfSongs;
                  var artist = snapshot.data![index].artist;
                  int albumId = snapshot.data![index].id;
                  // print(albumId);

                  return FutureBuilder<Uint8List?>(
                    future: _musicPlayerController.audioQuery.queryArtwork(
                      snapshot.data![index].id,
                      ArtworkType.ALBUM,
                      format: ArtworkFormat.PNG,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return InkWell(
                          onTap: () {
                            Get.to(AlbumMusicPage(albumId: albumId, albumName: albumName, albumArtistName: artist,));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 150,
                                    width: 200,
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      albumName,
                                      // overflow: TextOverflow.ellipsis, // Handle overflow
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                        fontSize: 12.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "$artist | $numOfTracks ${numOfTracks > 1 ? 'tracks' : 'track'}  ",
                                      style:
                                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Get.to(AlbumMusicPage(albumId: albumId, albumName: albumName, albumArtistName: artist,));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 150,
                                    width: 200,
                                    child: Image.asset(
                                      "assets/images/songs_tab.png",
                                      fit: BoxFit.cover,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      albumName,
                                      // overflow: TextOverflow.ellipsis, // Handle overflow
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "$artist | $numOfTracks ${numOfTracks > 1 ? 'tracks' : 'track'}  ",
                                      style:
                                      Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
