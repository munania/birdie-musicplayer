import 'package:flutter/material.dart';

class AddSongToPlaylist extends StatelessWidget {
  final int id;
  final String playlistName;

  const AddSongToPlaylist({super.key, required this.id, required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}
