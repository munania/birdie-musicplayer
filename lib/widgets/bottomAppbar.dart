import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/musicPlayerController.dart';
import '../theme/theme_constants.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final MusicPlayerController _musicPlayerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/artitst_detail_top.png'),
              // Replace with your image
              radius: 20.0,
            ),
            const SizedBox(width: 16.0),
            SizedBox(
              width: 180,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Obx(
                      () => Text(
                        _musicPlayerController.currentSongTitle.value,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => Text(
                        _musicPlayerController.artistName.value,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                //skip to previous
                InkWell(
                  onTap: () {
                    if (_musicPlayerController.player.hasPrevious) {
                      _musicPlayerController.player.seekToPrevious();
                    }
                  },
                  child: const Icon(
                    Icons.skip_previous,
                    size: 30,
                    color: darkTextColor,
                  ),
                ),

                // Pause or play track
                InkWell(
                  onTap: () {
                    if (_musicPlayerController.player.playing) {
                      _musicPlayerController.player.pause();
                    } else {
                      if (_musicPlayerController.player.currentIndex != null) {
                        _musicPlayerController.player.play();
                      }
                    }
                  },
                  child: StreamBuilder<bool>(
                    stream: _musicPlayerController.player.playingStream,
                    builder: (context, snapshot) {
                      bool? playingState = snapshot.data;
                      if (playingState != null && playingState) {
                        return const Icon(
                          Icons.pause,
                          size: 30,
                          color: darkTextColor,
                        );
                      }
                      return const Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: darkTextColor,
                      );
                    },
                  ),
                ),

                //skip to next
                InkWell(
                  onTap: () {
                    if (_musicPlayerController.player.hasNext) {
                      _musicPlayerController.player.seekToNext();
                    }
                  },
                  child: const Icon(
                    Icons.skip_next,
                    color: darkTextColor,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
