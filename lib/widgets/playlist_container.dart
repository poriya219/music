import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/albuminfo_screen/view/albuminfo_screen.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumContainer extends StatefulWidget {
  AlbumModel album;

  AlbumContainer({required this.album});

  @override
  State<AlbumContainer> createState() => _AlbumContainerState();
}

class _AlbumContainerState extends State<AlbumContainer> {
  final homeController = Get.find<Home_Controller>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> albumSongs = [];
  final playlist = ConcatenatingAudioSource(children: []);


  @override
  void initState() {
    super.initState();
    getAlbumSongs();
    // setInitialPlaylist();
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

  sourceListGetter() async {
    List<SongModel> list = albumSongs;
    if(list.isNotEmpty){
      for(var each in list){
        playlist.add(AudioSource.uri(Uri.file(each.data),
          tag: kAudioMetadata(
            album: each.album!,
            title: each.title,
            artist: each.artist ?? 'No Artist',
            artwork:
            QueryArtworkWidget(
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

  // void setInitialPlaylist() async {
  //   playlist = ConcatenatingAudioSource(children: []);
  //   for(int i = 0; i < albumSongs.length; i++){
  //     playlist.add(AudioSource.uri(Uri.parse(albumSongs[i].uri!)));
  //   }
  //   await playerService.player.setAudioSource(playlist);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: GestureDetector(
        onTap: () {
          Get.to(() => AlbumInfoScreen(album: widget.album));
        },
        child: Stack(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: QueryArtworkWidget(
                  id: widget.album.id,
                  type: ArtworkType.ALBUM,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                  format: ArtworkFormat.JPEG,
                  artworkFit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 90,
              left: 2,
              child: Container(
                height: 60,
                width: 157,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kLighterPurple.withOpacity(0.85),
                      kDarkPurple.withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 112,
                          child: Text(
                            widget.album.album,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          '${widget.album.numOfSongs} Song',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async{
                          setState((){
                            homeController.trackTitle = albumSongs[0].title.obs;
                            homeController.trackArtist = albumSongs[0].artist.obs;
                            homeController.trackid = albumSongs[0].id.obs;
                            // songController.setSongTrack(track.title, track.artist!, track.id);
                            playerService.currentPlayTrack = albumSongs[0];
                            // musicController.newSong;
                          });
                          await playerService.player.setAudioSource(playlist);
                          homeController.update();
                          await playerService.player.play();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
