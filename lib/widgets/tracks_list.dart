import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class TracksList extends StatefulWidget {
  const TracksList({Key? key}) : super(key: key);

  @override
  State<TracksList> createState() => _TracksListState();
}

class _TracksListState extends State<TracksList> {
  final homeController = Get.find<Home_Controller>();

  final playlist = ConcatenatingAudioSource(children: []);

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    await sourceListGetter();
  }


  sourceListGetter() async{
    List<SongModel> list = await kSongList;
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
      Timer(const Duration(seconds: 1), () {sourceListGetter();});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        SongModel track = kSongList[index];
        return InkWell(
          onTap: () async {
            setState(() {
              homeController.trackTitle = track.title.obs;
              homeController.trackArtist = track.artist.obs;
              homeController.trackid = track.id.obs;
              // songController.setSongTrack(track.title, track.artist!, track.id);
              playerService.currentPlayTrack = track;
              // playerService.player.setFilePath(track.data);
              playerService.player.setAudioSource(playlist,initialIndex: index);
              playerService.player.play();
              // musicController.newSong;
              Get.to(Track_Screen(
                track: track,
              ));
            });
            homeController.update();
          },
          child: Card(
            child: ListTile(
              // leading: QueryArtworkWidget(
              //     id: track.id, type: ArtworkType.AUDIO),
              leading: Container(
                height: 55,
                width: 55,
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
              title: Text(track.title),
              subtitle: Text(track.artist ?? ''),
            ),
          ),
        );
      },
      itemCount: kSongList.length,
    );
  }
}
