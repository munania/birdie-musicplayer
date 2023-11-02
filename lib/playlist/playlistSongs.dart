import 'package:flutter/material.dart';
import 'package:musicplayer/playlist/playlist.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailScreen(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlist.songs.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(playlist.songs[index].title),
          subtitle: Text(playlist.songs[index].artist!),
          // Add more UI components as needed
        );
      },
    );
  }
}
