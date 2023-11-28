import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayerController extends GetxController {

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  // RxBool isPlayerViewVisible = false.obs;
  RxInt currentIndex = 0.obs;
  RxString currentSongTitle = ''.obs;
  RxString artistName = ''.obs;

  // void togglePlayerViewVisibility() {
  //   isPlayerViewVisible.toggle();
  // }

  @override
  void onInit() {
    super.onInit();

    // Add any initialization logic here if needed.
  }

  AudioPlayer get player => _player;
  OnAudioQuery get audioQuery => _audioQuery;

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

// Add other methods and variables as needed for your music player logic
}
