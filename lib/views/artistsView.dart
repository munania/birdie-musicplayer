import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'artistsDetailsPage.dart';

class ArtistsView extends StatefulWidget {
  const ArtistsView({super.key});

  @override
  State<ArtistsView> createState() => _ArtistsViewState();
}

class _ArtistsViewState extends State<ArtistsView> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<ArtistModel>>(
          future: _audioQuery.queryArtists(
            orderType: OrderType.DESC_OR_GREATER,
            sortType: ArtistSortType.ARTIST,
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
                String artistName = snapshot.data![index].artist;
                int artistId = snapshot.data![index].id;
                var numOfTracks = snapshot.data![index].numberOfTracks;

                return FutureBuilder<Uint8List?>(
                  future: _audioQuery.queryArtwork(
                    snapshot.data![index].id,
                    ArtworkType.ARTIST,
                    format: ArtworkFormat.PNG,
                  ),
                  builder: (context, artworkSnapshot) {
                    if (artworkSnapshot.hasData && artworkSnapshot.data != null) {
                      return FutureBuilder<List<AlbumModel>>(
                        future: _audioQuery.queryAlbums(
                          orderType: OrderType.DESC_OR_GREATER,
                          sortType: AlbumSortType.ARTIST,
                          ignoreCase: true,
                        ),
                        builder: (context, albumSnapshot) {
                          var artistAlbums = albumSnapshot.data
                              ?.where((album) => album.artist == artistName)
                              .toList();

                          return ListTile(
                            onTap: () {
                              Get.to(ArtistDetailPage(artistName: artistName, artistId: artistId ,));
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
                            subtitle: Text(
                              "$numOfTracks ${numOfTracks! > 1 ? 'tracks' : 'track'} | ${artistAlbums?.length} albums",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return ListTile(
                        onTap: () {
                          Get.to(ArtistDetailPage(artistName: artistName, artistId: artistId ,));
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
                        subtitle: Text(
                          "$numOfTracks ${numOfTracks! > 1 ? 'tracks' : 'track'} | 2 albums",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      );
                    }
                  },
                );

              },
            );
          },
        ),
      ),
    );
  }
}
