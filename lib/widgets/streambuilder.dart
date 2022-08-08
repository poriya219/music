import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/track_screen/controller/trackscreen_controller.dart';
import 'package:music/services/player_service.dart';

class DurationStream extends StatefulWidget {
  double time;
  Size size;

  DurationStream({required this.time,required this.size});

  @override
  State<DurationStream> createState() => _DurationStreamState();
}

class _DurationStreamState extends State<DurationStream> {
  // final trackController = Get.find<TrackScreenController>();
  @override
  Widget build(BuildContext context) {
    final playerService = Get.put(Player_Service());

    return StreamBuilder<Duration?>(
      stream: playerService.player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: playerService.player.positionStream,
          builder: (context, snapshot) {
            var position = snapshot.data ?? Duration.zero;
            if (position > duration) {
              position = duration;
            }
            return Container(
              child: Column(
                children: [
                  Slider(
                    inactiveColor: Colors.grey,
                    activeColor: kLighterPurple,
                    min: 0,
                    max: playerService.player.duration?.inSeconds.toDouble() ?? 0.0,
                    value: double.parse(position.inSeconds.toString()),
                    onChanged: (value) {
                      setState((){
                        widget.time = value;
                        playerService.player.seek(Duration(seconds: value.toInt()));
                      });

                    },
                  ),
                  SizedBox(
                    width: widget.size.width * 0.88,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Obx(() => Text(trackController.currentTrackPosition.toString().split('.').first),),
                        Text(position.toString().split('.').first),
                        Text(duration.toString().split('.').first),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
