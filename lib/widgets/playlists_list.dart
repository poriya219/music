import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/const.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistsList extends StatefulWidget {
  const PlaylistsList({Key? key}) : super(key: key);

  @override
  State<PlaylistsList> createState() => _PlaylistsListState();
}

class _PlaylistsListState extends State<PlaylistsList> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  getPlayLists() async {
    kPlayList = await audioQuery.queryPlaylists();
    print(kPlayList);
    setState(() {});
  }

  TextEditingController playlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final OnAudioQuery audioQuery = OnAudioQuery();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        PlaylistModel playlist = kPlayList[index];
        return InkWell(
          onTap: () async {
            print(kPlayList);
            // print('$status1 $status2 $status3');
          },
          child: Card(
            child: ListTile(
              leading: Icon(Icons.playlist_play),
              title: Text(playlist.playlist),
              subtitle: Text('${playlist.numOfSongs} Songs'),
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              Container(
                                width: 250,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        bool status = await audioQuery.removePlaylist(playlist.id);
                                        setState((){});
                                      },
                                        child: const Card(
                                      child: ListTile(
                                          leading:
                                              Icon(Icons.delete_forever),
                                      title: Text('Delete'),
                                      ),
                                    )),
                                    GestureDetector(
                                        onTap: () async{
                                          playlistNameController.text = playlist.playlist;
                                          Get.back();
                                          showDialog(context: context, builder: (context){
                                            return AlertDialog(
                                              title: Text('Add Playlist'),
                                              actions: [
                                                TextField(
                                                  controller: playlistNameController,
                                                ),
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
                                                        onTap: () {
                                                          String name = playlistNameController.text;
                                                          audioQuery.renamePlaylist(playlist.id, name);

                                                          Get.back();
                                                        },
                                                        child: Text('Edit')),
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
                                          setState((){});
                                        },
                                        child: const Card(
                                          child: ListTile(
                                            leading:
                                            Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.more_vert)),
            ),
          ),
        );
      },
      itemCount: kPlayList.length,
    );
  }
}
