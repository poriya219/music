import 'package:get/get.dart';
import 'package:music/services/player_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
//
final playerService = Get.find<Player_Service>();
SongModel track = playerService.currentPlayTrack;
//
class Home_Controller extends GetxController{

RxString trackTitle = ''.obs;
Rx<String?> trackArtist = ''.obs;

RxInt trackid = 0.obs;

}