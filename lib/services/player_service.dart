import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

Map defaultsongModel = {
  "_data": '',
  "_display_name": '',
  "_id": 00000,
  "album": 'song.album',
  "album_id": 1,
  "artist": '',
  "artist_id": 1,
  "date_added": DateTime.now(),
  "duration": Duration.zero,
  "title": 'No Music Playing',
  "artwork": 0,
};

class Player_Service {

  final player = AudioPlayer();



  SongModel currentPlayTrack = SongModel(defaultsongModel);


}