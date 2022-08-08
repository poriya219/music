import 'package:flutter/material.dart';
import 'package:music/const.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistsList extends StatelessWidget {
  const ArtistsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        ArtistModel artist = kArtistList[index];
        return InkWell(
          onTap: () {},
          child: Card(
            child: ListTile(
              title: Text(artist.artist),
              subtitle: Text('${artist.numberOfAlbums} Albums ${artist.numberOfTracks} Songs'),
            ),
          ),
        );
      },
      itemCount: kArtistList.length,
    );
  }
}
