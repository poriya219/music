import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/controller/home_controller.dart';
import 'package:music/screens/search_screen/view/search_screen.dart';
import 'package:music/screens/home_screen/view/home_screen.dart';
import 'package:music/screens/song_detect/view/song_detect.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:music/services/player_service.dart';
import 'package:music/widgets/album_list.dart';
import 'package:music/widgets/artist_list.dart';
import 'package:music/widgets/genres_list.dart';
import 'package:music/widgets/playlists_list.dart';
import 'package:music/widgets/tracks_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Songs_Screen extends StatefulWidget {
  List<SongModel> songList;
  String listType;

  Songs_Screen({Key? key, required this.songList, required this.listType}) : super(key: key);

  @override
  State<Songs_Screen> createState() => _Songs_ScreenState();
}

class _Songs_ScreenState extends State<Songs_Screen> {
  // final songController = Get.put(Song_Controller());
  final playerService = Get.put(Player_Service());
  final homeController = Get.find<Home_Controller>();
  TextEditingController playlistNameController = TextEditingController();
  PanelController songsscreencontroller = PanelController();
  final OnAudioQuery audioQuery = OnAudioQuery();
  late Size size;



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
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
                height: 14,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    ListType('Albums'),
                    ListType('Artists'),
                    ListType('Tracks'),
                    ListType('Playlists'),
                    ListType('Genres'),
                  ],
                ),
              ),
              Visibility(
                visible: widget.listType == 'Playlists',
                child: GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('Add Playlist'),
                        actions: [
                          Expanded(child: TextField(
                            controller: playlistNameController,
                          )),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    Get.back();
                                  },
                                  child: Text('Cancel')),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              GestureDetector(
                                  onTap: () async{
                                    audioQuery.createPlaylist(playlistNameController.text);
                                    kPlayList = await audioQuery.queryPlaylists();
                                    setState((){});
                                    Get.back();
                                  },
                                  child: Text('Add')),
                              SizedBox(
                                width: size.width * 0.025,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      );
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.03,),
                      Icon(Icons.add,color: Colors.grey,),
                      Text('Add',style: TextStyle(fontSize: 17,color: Colors.grey),),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: (widget.listType == 'Albums')
                    ? const AlbumsList()
                    : (widget.listType == 'Artists')
                        ? const ArtistsList()
                        : (widget.listType == 'Tracks')
                            ? const TracksList()
                            : (widget.listType == 'Playlists')
                                ? const PlaylistsList()
                                : const GenresList(),
              ),
            ],
          ),
        );
  }

  Widget ListType(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.listType = text;
        });
      },
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text,
                style: TextStyle(
                    color: (widget.listType == text) ? kDarkPurple : Colors.grey,
                    fontSize: 20),
              )),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 70,
            child: Visibility(
                visible: text == widget.listType,
                child: const Divider(thickness: 3,color: kLighterPurple)),
          )
        ],
      )
    );
  }
}
