import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

const Color kDarkPurple = Color.fromARGB(255, 38, 10, 65);
const Color kLighterPurple = Color.fromARGB(255, 81, 26, 126);

List<SongModel> kSongList = [];
List<SongModel> kRecentSongList = [];
List<AlbumModel> kAlbumList = [];
List<ArtistModel> kArtistList = [];
List<PlaylistModel> kPlayList = [];
List<GenreModel> kGenreList = [];


class kAudioMetadata {
  final String album;
  final String title;
  final String artist;
  final QueryArtworkWidget artwork;

  kAudioMetadata({
    required this.album,
    required this.title,
    required this.artist,
    required this.artwork,
  });
}


const kApiKey = '643bbc149794d9a140fc7438b4699dc7';
const kApiSecret = 'S3Q7dYcR0VzVYFVxlGZFuWTYCiemVo0uXyXLnWKf';
const kHost = 'identify-eu-west-1.acrcloud.com';



void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                inactiveColor: Colors.grey,
                activeColor: kLighterPurple,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}