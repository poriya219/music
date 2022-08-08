import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/track_screen/controller/trackscreen_controller.dart';
import 'package:music/widgets/trackrowcontroller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music/services/player_service.dart';

class TrackRow extends StatefulWidget {
  final Color color;
  SongModel track;

  TrackRow({required this.color, required this.track});

  @override
  State<TrackRow> createState() => _TrackRowState();
}

class _TrackRowState extends State<TrackRow> {
  late Size size;
  final homeController = Get.find<Home_Controller>();
  final playerService = Get.find<Player_Service>();
  final trackRowController = Get.put(TrackRowController());

  @override
  void initState(){
    super.initState();
    indexGetter();
  }

  void indexGetter(){
    Timer(Duration(seconds: 1), () {
      int index = playerService.player.currentIndex ?? 0;
      trackRowController.setCurrentIndex(index);
      indexGetter();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = playerService.player.playing;
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const SizedBox(
            width: 15,
          ),
          // Container(
          //     height: 70,
          //     width: 70,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       color: Colors.white,
          //     ),
          //     child: GetBuilder(
          //       init: Home_Controller(),
          //       builder: (context){
          //       return ClipRRect(
          //           borderRadius: BorderRadius.circular(20),
          //           child: QueryArtworkWidget(
          //             id: homeController.trackid.value,
          //             type: ArtworkType.AUDIO,
          //             artworkBorder: BorderRadius.circular(20),
          //           ));
          //     },),),
          GetBuilder<TrackRowController>(builder: (TrackRowController){
            return StreamBuilder(
                stream: playerService.player.sequenceStream,
                builder: (BuildContext context,AsyncSnapshot snapshot) {
                  List list = snapshot.data ?? [];
                  QueryArtworkWidget artwork = list.isNotEmpty ? list[trackRowController.currentIndex].tag.artwork : QueryArtworkWidget(id: 0, type: ArtworkType.AUDIO,);
                  return Center(
                    child: Container(
                      height: 70,
                      width: 70,
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
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: size.width * 0.44,
                  // child: GetBuilder(
                  //     init: Home_Controller(),
                  //     builder: (context){
                  //   return Text(
                  //     homeController.trackTitle.string,
                  //     style: TextStyle(color: widget.color, fontSize: 20),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //   );
                  // }),
                child: GetBuilder<TrackRowController>(builder: (TrackRowController){
                  return StreamBuilder(
                      stream: playerService.player.sequenceStream,
                      builder: (BuildContext context,AsyncSnapshot snapshot){
                        List list = snapshot.data ?? [];
                        String title = list.isNotEmpty ? list[trackRowController.currentIndex].tag.title : 'No Music Playing';
                        return Text(
                          title,
                          style: TextStyle(color: widget.color, fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      });
                }),
              ),
              const SizedBox(
                height: 7,
              ),
              // GetBuilder(
              //     init: Home_Controller(),
              //     builder: (context){
              //       return SizedBox(
              //         width: size.width * 0.45,
              //         child: Text(
              //           homeController.trackArtist.string,
              //           // '',
              //           style: const TextStyle(color: Colors.grey, fontSize: 14),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       );
              //     }),
              GetBuilder<TrackRowController>(builder: (TrackRowController){
                return StreamBuilder(
                    stream: playerService.player.sequenceStream,
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      List list = snapshot.data ?? [];
                      String title = list.isNotEmpty ? list[trackRowController.currentIndex].tag.artist : '';
                      return Text(
                        title,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    });
              }),
            ],
          ),
          const Spacer(),
          StreamBuilder<PlayerState>(
            stream: playerService.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 40.0,
                  height: 40.0,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      playerService.player.play();
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      playerService.player.pause();
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pause,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      playerService.player.seek(Duration.zero);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

}
