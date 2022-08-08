import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music/const.dart';
import 'package:music/screens/albuminfo_screen/view/albuminfo_screen.dart';
import 'package:music/screens/genreinfo_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GenresList extends StatelessWidget {
  const GenresList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        GenreModel genre = kGenreList[index];
        return InkWell(
          onTap: () async {
            Get.to(GenreScreen(genre: genre),);
          },
          child: Card(
            child: ListTile(
              title: Text(genre.genre),
              subtitle: Text('${genre.numOfSongs} Songs'),
            ),
          ),
        );
      },
      itemCount: kGenreList.length,
    );
  }
}
