// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../constants/colors.dart';
//
// class Playlist extends StatefulWidget {
//   const Playlist({super.key});
//
//   @override
//   State<Playlist> createState() => _PlaylistState();
// }
//
// class _PlaylistState extends State<Playlist> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.bg,
//         elevation: 0,
//         title: Row(
//           children: [
//             const Text("Musically"),
//             const SizedBox(
//               width: 15,
//             ),
//             Expanded(
//               child: Container(
//                 height: 38,
//                 decoration: BoxDecoration(
//                   color: const Color(0xff292E4B),
//                   borderRadius: BorderRadius.circular(19),
//                 ),
//                 child: TextField(
//                   // controller: controller,
//                   decoration: InputDecoration(
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 20),
//                       prefixIcon: Container(
//                         margin: const EdgeInsets.only(left: 20),
//                         alignment: Alignment.centerLeft,
//                         width: 30,
//                         child: Image.asset(
//                           "assets/images/search.png",
//                           width: 20,
//                           height: 20,
//                           fit: BoxFit.contain,
//                           color: AppColor.primaryText28,
//                         ),
//                       ),
//                       hintText: "Search album song",
//                       hintStyle: TextStyle(
//                         color: AppColor.primaryText28,
//                         fontSize: 13,
//                       )),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("My Playlist")
//           ]
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(onPressed: () {
//         Get.defaultDialog(
//           backgroundColor: AppColor.secondaryEnd,
//           title: "Create new playlist",
//           titleStyle: TextStyle(color: AppColor.primaryText),
//           barrierDismissible: true,
//           content: const Column(
//             children: [
//               Text("data"),
//               TextField(),
//             ],
//           ),
//         );
//       }, label: const Text("Create Playlist"),),
//     );
//   }
// }
//
// // Identify data source
// // Modelling the data
// // Developing
// // Model, com up with
// // Data to inform development
// // What to do with the data

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class Playlist {
  String name;
  List<SongModel> songs;

  Playlist(this.name, this.songs);
}


class PlaylistScreen extends StatelessWidget {
  final List<Playlist> playlists;

  const PlaylistScreen(this.playlists, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(playlists[index].name),
            onTap: () {
              // Navigate to the screen to add songs to the selected playlist
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddSongScreen(playlists[index]),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}

