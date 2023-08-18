import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music/const.dart';
import 'package:music/screens/home_screen/view/home_screen.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:music/screens/songs_screen/view/songs_screen.dart';
import 'package:music/screens/track_screen/view/track_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox<SongModel>('last_track');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  JustAudioPlatform? _pluginPlatformCache;

  JustAudioPlatform get pluginPlatform {
    var pluginPlatform = JustAudioPlatform.instance;
    if (_pluginPlatformCache == null) {
      try {
        pluginPlatform.disposeAllPlayers(DisposeAllPlayersRequest());
      } catch (e) {
        // Silently ignore if a platform doesn't support this method.
      }
      _pluginPlatformCache = pluginPlatform;
    }
    return pluginPlatform;
  }

  final OnAudioQuery audioQuery = OnAudioQuery();


  getSongs() async {
    kSongList = await audioQuery.querySongs();
  }

  getAlbums() async {
    // AlbumSortType.ALBUM,
    kAlbumList = await audioQuery.queryAlbums();
  }


  getRecentSongs() async {
    kRecentSongList = await audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
    );
    FlutterNativeSplash.remove();
  }

  getArtists() async {
    ArtistSortType.NUM_OF_TRACKS;
    OrderType.ASC_OR_SMALLER;
    kArtistList = await audioQuery.queryArtists();
  }

  getPlayLists() async {

    kPlayList = await audioQuery.queryPlaylists();
    audioQuery.renamePlaylist(68481, 'newName');
    print(kPlayList);
    for(var each in kSongList){
      if(DateTime.fromMillisecondsSinceEpoch(each.dateAdded! * 1000).isAfter(DateTime.now().subtract(Duration(days: 30)))){
        audioQuery.addToPlaylist(kPlayList.first.id, each.id);
      }
    }
  }

  getGenre() async {
    kGenreList = await audioQuery.queryGenres();
  }




  void requestStoragePermission() async {
    if (!kIsWeb) {
      print('is not web');
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    getSongs();
    getAlbums();
    getRecentSongs();
    getArtists();
    getGenre();
    getPlayLists();

  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Home_Screen(songList: kSongList,albumList: kAlbumList,recentSongList: kRecentSongList,screen: 'Home'),
    );
  }
}

