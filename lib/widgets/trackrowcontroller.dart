import 'package:get/get.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';

class TrackRowController extends GetxController{
  int currentIndex = playerService.player.currentIndex ?? 0;

  void setCurrentIndex(int index){
    currentIndex = index;
    update();
  }
}