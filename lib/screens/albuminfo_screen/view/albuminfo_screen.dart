import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumInfoScreen extends StatefulWidget {
  AlbumModel album;

  AlbumInfoScreen({required this.album});

  @override
  State<AlbumInfoScreen> createState() => _AlbumInfoScreenState();
}

class _AlbumInfoScreenState extends State<AlbumInfoScreen> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  PanelController trackscreencontroller = PanelController();
  final homeController = Get.find<Home_Controller>();
  late Size size;
  List<SongModel> albumSongs = [];
  final playlist = ConcatenatingAudioSource(children: []);

  @override
  void initState() {
    super.initState();
    getAlbumSongs();
    sourceListGetter();
  }

  getAlbumSongs() async {
    albumSongs = await audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      widget.album.id,
      // You can also define a sortType
      sortType: SongSortType.TITLE, // Default
      orderType: OrderType.ASC_OR_SMALLER, // Default
    );
    setState((){});
  }

  sourceListGetter() async{
    List<SongModel> list = await albumSongs;
    if(list.isNotEmpty){
      for(var each in list){
        playlist.add(AudioSource.uri(Uri.file(each.data),
          tag: kAudioMetadata(
            album: each.album!,
            title: each.title,
            artist: each.artist ?? '',
            artwork:
            QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(20),
                artworkQuality: FilterQuality.high,
                  size: 5000,
                  quality: 100,
                  format: ArtworkFormat.JPEG,
                  id: each.id, type: ArtworkType.AUDIO),
          ),
        ),
        );
        // print('====================================================== $list');
      }
    }
    else{
      Timer(Duration(seconds: 1), () {sourceListGetter();});
    }
  }



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        defaultPanelState: PanelState.OPEN,
        controller: trackscreencontroller,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        backdropOpacity: 0.3,
        minHeight: size.height * 0.70,
        maxHeight: size.height * 0.70,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.38,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: QueryArtworkWidget(
                          artworkBorder: BorderRadius.zero,
                          size: 5000,
                          format: ArtworkFormat.JPEG,
                          quality: 100,
                          artworkQuality: FilterQuality.high,
                          id: widget.album.id,
                          artworkFit: BoxFit.fill,
                          artworkHeight: size.height * 0.3,
                          artworkWidth: size.width,
                          type: ArtworkType.ALBUM)),
                ),
                Container(
                  color: Colors.white,
                  height: size.height * 0.6,
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Column(
            //     children: [
            //       const SizedBox(
            //         height: 40,
            //       ),
            //       Container(
            //         width: 30,
            //         height: 30,
            //         decoration: BoxDecoration(
            //           color: kLighterPurple,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Center(
            //           child: IconButton(onPressed: (){
            //             Get.back();
            //           }, icon: const Icon(Icons.arrow_back,size: 28,color: Colors.white,)),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
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
                height: 20,
              ),
              Text(
                widget.album.album,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.album.artist ?? '',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none),
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(thickness: 1.5),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.album.numOfSongs,
                  itemBuilder: (BuildContext context, int index) {
                    SongModel track = albumSongs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: GestureDetector(
                        onTap: (){
                          setState((){
                            homeController.trackTitle = track.title.obs;
                            homeController.trackArtist = track.artist.obs;
                            homeController.trackid = track.id.obs;
                            // songController.setSongTrack(track.title, track.artist!, track.id);
                            playerService.currentPlayTrack = track;
                            playerService.player.setAudioSource(playlist,initialIndex: index);
                            // playerService.player.setFilePath(track.data);
                            playerService.player.play();
                            Get.to(Track_Screen(track: track,));
                          });
                          homeController.update();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: QueryArtworkWidget(
                                    id: track.id,
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(20),
                                  )),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: Text(
                                    track.title,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: size.width * 0.67,
                                  child: Text(
                                    track.artist ?? '',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.more_vert),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


