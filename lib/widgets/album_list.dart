import 'package:flutter/material.dart';
import 'package:music/const.dart';
import 'package:music/widgets/playlist_container.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: kAlbumList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 256 / 256,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          AlbumModel album = kAlbumList[index];
          return Center(child: AlbumContainer(album: album,));
        });
  }
}
