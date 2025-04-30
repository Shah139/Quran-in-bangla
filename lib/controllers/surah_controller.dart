import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class SurahController extends GetxController {
  var surahData = {}.obs;
  var isLoading = false.obs;
  var currentAyahIndex = 0.obs;
  var isPlaying = false.obs;
  var progress = 0.0.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  
  final AudioPlayer audioPlayer = AudioPlayer();
  
  @override
  void onInit() {
    super.onInit();
    setupAudioPlayer();
  }
  
  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
  
  void setupAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
    
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });
    
    audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
      if (duration.value.inMilliseconds > 0) {
        progress.value = position.value.inMilliseconds / 
                        duration.value.inMilliseconds;
      }
    });
    
    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      progress.value = 0;
      playNextAyah();
    });
  }

  Future<void> fetchSurah(int surahNumber) async {
    isLoading(true);
    try {
      var response = await http.get(Uri.parse('https://quran.sayed.page/api/$surahNumber'));
      if (response.statusCode == 200) {
        surahData.value = jsonDecode(response.body);
        currentAyahIndex.value = 0;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load Surah');
    } finally {
      isLoading(false);
    }
  }
  
  Future<void> playAyah(int index) async {
    if (index >= 0 && index < (surahData['ayah'] ?? []).length) {
      currentAyahIndex.value = index;
      await audioPlayer.stop();
      
      var ayah = surahData['ayah'][index];
      String fullAudioUrl = 'https://quran.sayed.page${ayah['audio']}';
      
      await audioPlayer.setReleaseMode(ReleaseMode.stop);
      await audioPlayer.play(UrlSource(fullAudioUrl));
    }
  }
  
  void togglePlayPause() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      if (position.value.inMilliseconds == 0) {
        playAyah(currentAyahIndex.value);
      } else {
        await audioPlayer.resume();
      }
    }
  }
  
  void playNextAyah() {
    int nextIndex = currentAyahIndex.value + 1;
    if (nextIndex < (surahData['ayah'] ?? []).length) {
      playAyah(nextIndex);
    }
  }
  
  void playPreviousAyah() {
    int prevIndex = currentAyahIndex.value - 1;
    if (prevIndex >= 0) {
      playAyah(prevIndex);
    }
  }
  
  void seekTo(double value) {
    final newPosition = Duration(milliseconds: 
      (value * duration.value.inMilliseconds).round());
    audioPlayer.seek(newPosition);
  }
}