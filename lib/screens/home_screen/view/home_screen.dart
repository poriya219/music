import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/const.dart';
import 'package:music/lib.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/home_screen/view/home_screen.dart';
import 'package:music/screens/search_screen/view/search_screen.dart';
import 'package:music/screens/song_detect/view/song_detect.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:music/screens/songs_screen/view/songs_screen.dart';
import 'package:music/services/player_service.dart';
import 'package:music/widgets/playlist_container.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:music/widgets/track_row.dart';

class Home_Screen extends StatefulWidget {
  List<SongModel> songList;
  List<SongModel> recentSongList;
  List<AlbumModel> albumList;
  String screen;

  Home_Screen(
      {required this.songList,
      required this.albumList,
      required this.recentSongList,
      required this.screen});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  late Size size;
  final playerService = Get.put(Player_Service());
  final homeController = Get.put(Home_Controller());
  PanelController panelController = PanelController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = playerService.player.playing;
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SlidingUpPanel(
              onPanelClosed: (){
                if(widget.screen != 'Home'){
                  setState((){
                    currentIndex = 0;
                    widget.screen = 'Home';
                  });
                }
              },
              backdropEnabled: true,
              backdropOpacity: 0.3,
              controller: panelController,
              maxHeight: size.height * 0.62,
              minHeight: size.height * 0.35,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kLighterPurple,
                    Colors.white,
                  ],
                )),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.menu,
                                  size: 32,
                                  color: Colors.white.withOpacity(0.5),
                                )),
                            const Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.shield_moon_rounded,
                                  size: 32,
                                  color: Colors.white.withOpacity(0.5),
                                )),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              12 > DateTime.now().hour &&
                                      DateTime.now().hour > 5
                                  ? 'Good Morning'
                                  : 21 > DateTime.now().hour &&
                                          DateTime.now().hour > 12
                                      ? 'Have a good day'
                                      : 'Good Night',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 27),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Pouria',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              panel: BodyMaker(),
            ),
          ),
          GestureDetector(
            onTap: () {
              SongModel track = playerService.currentPlayTrack;
              Get.to(Track_Screen(track: track));
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kLighterPurple,
                      kDarkPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TrackRow(
                    color: Colors.white, track: playerService.currentPlayTrack),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 100,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          selectedItemColor: kLighterPurple,
          unselectedItemColor: Colors.grey,
          onTap: (int i) {
            if (i == 0) {
              setState((){
                currentIndex = 0;
                panelController.panelPosition = 0.0;
                widget.screen = 'Home';

              });
            } else if (i == 1) {
              // Get.to(Songs_Screen(
              //   songList: widget.songList,
              //   listType: 'Tracks',
              // ));
              panelController.panelPosition = 1.0;
              setState((){
                currentIndex = 1;
                widget.screen = 'Songs';
              });
            } else if (i == 2) {
              Get.to(Search_Screen());
            }
            else{
              setState((){
                panelController.panelPosition = 1.0;
                currentIndex = 3;
                widget.screen = 'Detect';
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined), label: 'Songs'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Identify'),
          ]),
    );
  }

  Widget BodyMaker(){
    if (widget.screen == 'Home'){
      currentIndex = 0;
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            SizedBox(
                width: 50,
                child: Divider(
                    thickness: 3,
                    height: 5,
                    color: Colors.grey.withOpacity(0.5))),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Albums',
                  style: TextStyle(fontSize: 23),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState((){
                      currentIndex = 1;
                      panelController.panelPosition = 1.0;
                      widget.screen = 'Albums';
                    });
                  },
                  child: Text(
                    'See more',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  AlbumModel album = widget.albumList[index];
                  return AlbumContainer(
                    album: album,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Recently Aded',
                  style: TextStyle(fontSize: 23),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState((){
                      widget.screen = 'Playlists';
                      panelController.panelPosition = 1.0;
                      currentIndex = 1;
                    });
                  },
                  child: Text(
                    'See more',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  if(kRecentSongList != null) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          homeController.trackTitle = track.title.obs;
                          homeController.trackArtist = track.artist.obs;
                          homeController.trackid = track.id.obs;
                          playerService.currentPlayTrack =
                          widget.recentSongList[0];
                          playerService.player
                              .setFilePath(widget.recentSongList[0].data);
                          playerService.player.play();
                          Get.to(Track_Screen(
                            track: widget.recentSongList[0],
                          ));
                        });
                        homeController.update();
                      },
                      child: ListTile(
                        leading: Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: QueryArtworkWidget(
                                id: kRecentSongList[0].id,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(20),
                              )),
                        ),
                        title: Text(kRecentSongList.first.title),
                        subtitle:
                        Text(kRecentSongList[0].artist ?? ''),
                      ),
                    ),
                  ],
                  if(kRecentSongList != null) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          homeController.trackTitle = track.title.obs;
                          homeController.trackArtist = track.artist.obs;
                          homeController.trackid = track.id.obs;
                          playerService.currentPlayTrack =
                          widget.recentSongList[1];
                          playerService.player
                              .setFilePath(widget.recentSongList[0].data);
                          playerService.player.play();
                          Get.to(Track_Screen(
                            track: widget.recentSongList[1],
                          ));
                        });
                        homeController.update();
                      },
                      child: ListTile(
                        leading: Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: QueryArtworkWidget(
                                id: widget.recentSongList[0].id,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(20),
                              )),
                        ),
                        title: Text(widget.recentSongList[0].title),
                        subtitle:
                        Text(widget.recentSongList[0].artist ?? ''),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }
    else if(widget.screen == 'Songs') {
      currentIndex = 1;
      return Songs_Screen(songList: kSongList, listType: 'Tracks');
    }
    else if(widget.screen == 'Albums') {
      return Songs_Screen(songList: kSongList, listType: 'Albums');
    }
    else if(widget.screen == 'Playlists') {
      return Songs_Screen(songList: kSongList, listType: 'Playlists');
    }
    else{
      currentIndex = 3;
      return SongDetect();
    }
  }

}
