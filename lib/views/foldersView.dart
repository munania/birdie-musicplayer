import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class FoldersView extends StatefulWidget {
  const FoldersView({super.key});

  @override
  State<FoldersView> createState() => _FoldersViewState();
}

class _FoldersViewState extends State<FoldersView> {
  List<AudiosFromType> folders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: FutureBuilder<List<SongModel>>(
      //     future: _audioQuery.queryAudiosFrom(
      //       AudiosFromType.ARTIST,
      //
      //       sortType: SongSortType.ARTIST,
      //       orderType: OrderType.DESC_OR_GREATER,
      //       ignoreCase: true;
      //     ),
      //     builder: (context, snapshot) {
      //       if (kDebugMode) {
      //         print(snapshot.data);
      //       }
      //
      //       return Text("data");
      //     },
      //   ),
      // ),
    );
  }
}
