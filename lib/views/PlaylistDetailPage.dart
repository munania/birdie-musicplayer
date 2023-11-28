import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/musicPlayerController.dart';

class PlaylistDetailPage extends StatefulWidget {
  final int playlistId;
  final String playlistString;

  const PlaylistDetailPage(
      {super.key, required this.playlistId, required this.playlistString});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final MusicPlayerController _musicPlayerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistString),
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Edit PLaylist"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Delete Playlist"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              print("Editing Playlist");
            } else if (value == 1) {
              if (kDebugMode) {
                print("Deleting...........\n***DONE***");
              }
              _musicPlayerController.audioQuery.removePlaylist(widget.playlistId);
              Get.back();
            }
          }),
        ],
      ),
    );
  }
}
