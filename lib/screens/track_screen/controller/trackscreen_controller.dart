// import 'dart:async';
//
import 'package:get/get.dart';
import 'package:music/services/player_service.dart';
//
final playerService = Get.put(Player_Service());
//
class TrackScreenController extends GetxController{
  int currentIndex = playerService.player.currentIndex ?? 0;

  void setCurrentIndex(int index){
    currentIndex = index;
    update();
  }


}