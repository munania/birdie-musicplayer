import 'package:flutter/material.dart';
import 'package:musicplayer/playlist/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';


class AddSongScreen extends StatefulWidget {
  final Playlist playlist;
  final List<SongModel> allSongs;

  const AddSongScreen(this.playlist, this.allSongs, {super.key});

  @override
  AddSongScreenState createState() => AddSongScreenState();
}

class AddSongScreenState extends State<AddSongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Songs to Playlist')),
      body: ListView.builder(
        itemCount: widget.allSongs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.allSongs[index].title),
            onTap: () {
              setState(() {
                widget.playlist.songs.add(widget.allSongs[index]);
              });
            },
          );
        },
      ),
    );
  }
}

