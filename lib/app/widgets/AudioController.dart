import 'package:audioplayers/audioplayers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AudioPlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playAudio(String url) async {
    audioPlayer.play(AssetSource(url), volume: 1);
  }

  Future<void> pauseAudio() async {
    audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    audioPlayer.stop();
  }
}
