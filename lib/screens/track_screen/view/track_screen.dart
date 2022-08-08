
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/track_screen/controller/trackscreen_controller.dart';
import 'package:music/services/player_service.dart';
import 'package:music/widgets/streambuilder.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Track_Screen extends StatefulWidget {
  SongModel track;

  Track_Screen({required this.track});

  @override
  State<Track_Screen> createState() => _Track_ScreenState();
}

class _Track_ScreenState extends State<Track_Screen> {
  final playerService = Get.put(Player_Service());
  PanelController panelController = PanelController();
  final trackController = Get.put(TrackScreenController());
  late Size size;

  @override
  Widget build(BuildContext context) {

    LoopMode loopMode = playerService.player.loopMode;
    bool shuffleMode = playerService.player.shuffleModeEnabled;
    bool isPlaying = playerService.player.playing;
    // trackController.currentTrackPosition = playerService.player.position;
    double time = playerService.player.position.inSeconds.toDouble();
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlidingUpPanel(
        defaultPanelState: PanelState.OPEN,
        controller: panelController,
        onPanelClosed: () {
          Get.back();
        },
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        backdropEnabled: true,
        backdropOpacity: 0.3,
        maxHeight: size.height * 0.86,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kLighterPurple.withOpacity(0.65),
              Colors.white,
            ],
          )),
        ),
        panel: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 50,
                  child: Divider(
                      thickness: 3,
                      height: 5,
                      color: Colors.grey.withOpacity(0.5))),
              const SizedBox(
                height: 60,
              ),
              GetBuilder<TrackScreenController>(builder: (TrackScreenController){
                return StreamBuilder(
                    stream: playerService.player.sequenceStream,
                    builder: (BuildContext context,AsyncSnapshot snapshot) {
                      List list = snapshot.data;
                      QueryArtworkWidget artwork = list[trackController.currentIndex].tag.artwork;
                      return Center(
                        child: Container(
                          height: 290,
                          width: 290,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: artwork),
                        ),
                      );
                    });
              }),
              const SizedBox(
                height: 25,
              ),
              GetBuilder<TrackScreenController>(builder: (TrackScreenController){
                return StreamBuilder(
                    stream: playerService.player.sequenceStream,
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      List list = snapshot.data;
                      String title = list[trackController.currentIndex].tag.title;
                      return Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: 25),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    });
              }),
              const SizedBox(
                height: 7,
              ),
              GetBuilder<TrackScreenController>(builder: (TrackScreenController){
                return StreamBuilder(
                    stream: playerService.player.sequenceStream,
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      List list = snapshot.data;
                      String title = list[trackController.currentIndex].tag.artist;
                      return Text(
                        title,
                        style: const TextStyle(color: Colors.grey, fontSize: 19),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    });
              }),
              const SizedBox(
                height: 20,
              ),
              // Play_Slider(size: size,time: time),
              DurationStream(time: time, size: size),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showSliderDialog(
                          context: context,
                          title: "Adjust volume",
                          divisions: 10,
                          min: 0.0,
                          max: 1.0,
                          value: playerService.player.volume,
                          stream: playerService.player.volumeStream,
                          onChanged: playerService.player.setVolume,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          trackController.setCurrentIndex(playerService.player.previousIndex!);
                          playerService.player.seekToPrevious();
                        });
                      },
                      child: const Icon(
                        Icons.skip_previous,
                        size: 55,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isPlaying) {
                              playerService.player.pause();
                              isPlaying = false;
                            } else {
                              playerService.player.play();
                              isPlaying = true;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                kDarkPurple,
                                kLighterPurple.withOpacity(0.77),
                                Colors.white,
                              ],
                            ),
                          ),
                          child: Icon(
                            (isPlaying) ? Icons.pause : Icons.play_arrow,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          trackController.setCurrentIndex(playerService.player.nextIndex!);
                          playerService.player.seekToNext();
                        });
                      },
                      child: const Icon(
                        Icons.skip_next,
                        size: 55,
                        color: Colors.grey,
                      ),
                    ),
                    StreamBuilder<double>(
                      stream: playerService.player.speedStream,
                      builder: (context, snapshot) => IconButton(
                        icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust speed",
                            divisions: 10,
                            min: 0.5,
                            max: 1.5,
                            value: playerService.player.speed,
                            stream: playerService.player.speedStream,
                            onChanged: playerService.player.setSpeed,
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    color: kDarkPurple,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35),
                        topLeft: Radius.circular(35)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (loopMode == LoopMode.off) {
                                loopMode = LoopMode.one;
                                playerService.player.setLoopMode(LoopMode.one);
                              } else if (loopMode == LoopMode.one) {
                                loopMode = LoopMode.all;
                                playerService.player.setLoopMode(LoopMode.all);
                              } else {
                                loopMode = LoopMode.off;
                                playerService.player.setLoopMode(LoopMode.off);
                              }
                            });
                          },
                          icon: Icon(
                            (loopMode == LoopMode.off)
                                ? Icons.repeat_outlined
                                : loopMode == LoopMode.one
                                    ? Icons.repeat_one_outlined
                                    : Icons.repeat_outlined,
                            color: loopMode == LoopMode.off ? Colors.grey : Colors.white,
                            size: 30,
                          )),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.heart_broken,
                          size: 30,
                        ),
                        color: Colors.red,
                      ),
                      IconButton(
                        onPressed: () {
                          setState((){
                            if(!shuffleMode){
                              shuffleMode = true;
                            }
                            else{
                              shuffleMode = false;
                            }
                            playerService.player.setShuffleModeEnabled(shuffleMode);
                          });
                        },
                        icon: const Icon(
                          Icons.shuffle,
                          size: 30,
                        ),
                        color: shuffleMode ? Colors.white : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
