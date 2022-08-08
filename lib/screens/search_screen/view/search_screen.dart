import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/home_screen/view/home_screen.dart';
import 'package:music/screens/song_detect/view/song_detect.dart';
import 'package:music/screens/songs_screen/view/songs_screen.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  TextEditingController textEditingController = TextEditingController();
  List<SongModel> searchList = [];
  final homeController = Get.find<Home_Controller>();

  final playlist = ConcatenatingAudioSource(children: []);

  // sourceListGetter() {
  //   if(searchList.isNotEmpty){
  //     for(var each in searchList){
  //       playlist.add(AudioSource.uri(Uri.file(each.data),
  //         tag: kAudioMetadata(
  //           album: each.album!,
  //           title: each.title,
  //           artist: each.artist ?? '',
  //           artwork:
  //           QueryArtworkWidget(
  //               artworkQuality: FilterQuality.high,
  //               size: 5000,
  //               quality: 100,
  //               format: ArtworkFormat.JPEG,
  //               id: each.id, type: ArtworkType.AUDIO),
  //         ),
  //       ),
  //       );
  //       // print('====================================================== $list');
  //     }
  //   }
  //   else{
  //     Timer(const Duration(seconds: 1), () {sourceListGetter();});
  //   }
  // }
  playListGetter(){
    playlist.clear();
    for(var each in searchList){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: kLighterPurple,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: kLighterPurple),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onChanged: (value){
                      setState((){
                        search(value);
                        // sourceListGetter();
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                SongModel track = searchList[index];
                return InkWell(
                  onTap: () async {
                    playListGetter();
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
              itemCount: searchList.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          elevation: 30,
          backgroundColor: Colors.white,
          selectedItemColor: kLighterPurple,
          unselectedItemColor: Colors.grey,
          onTap: (int i) {
            if (i == 0) {
              Get.off(Home_Screen(
                songList: kSongList,
                albumList: kAlbumList,
                recentSongList: kRecentSongList,
                screen: 'Home',
              ));
            } else if (i == 1) {
              Get.off(Home_Screen(
                songList: kSongList,
                albumList: kAlbumList,
                recentSongList: kRecentSongList,
                screen: 'Songs',
              ));
            } else if (i == 2) {
            } else {
              Get.off(Home_Screen(
                songList: kSongList,
                albumList: kAlbumList,
                recentSongList: kRecentSongList,
                screen: 'Detect',
              ));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined), label: 'Songs'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.circle_outlined), label: 'Identify'),
          ]),
    );
  }

  void search(String searchText) {
    searchList.clear();
    if (searchText != ''){
      for (var searchSong in kSongList) {
        if (searchSong.title.contains(searchText.capitalize!)) {
          searchList.add(searchSong);
        }
        if (searchSong.artist!.contains(searchText.capitalize!)) {
          searchList.add(searchSong);
        }
      }
  }
  }

}
