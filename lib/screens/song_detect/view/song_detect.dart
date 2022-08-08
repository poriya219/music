import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:music/const.dart';

class SongDetect extends StatefulWidget {
  @override
  State<SongDetect> createState() => _SongDetectState();
}

class _SongDetectState extends State<SongDetect> {
  ACRCloudResponseMusicItem? music;

  late Size size;
  bool isActive = false;



  @override
  void initState() {
    super.initState();
    ACRCloud.setUp(const ACRCloudConfig(kApiKey, kApiSecret, kHost));
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: size.width,
      // height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: SizedBox(
                width: 50,
                child: Divider(
                    thickness: 3,
                    height: 2,
                    color: Colors.grey.withOpacity(0.5))),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          const Text('Identify',style: TextStyle(color: kDarkPurple, fontSize: 20),),
          SizedBox(
            height: size.height * 0.05,
          ),
          if (isActive == true) ...[
            const Text(
              'Listening...',
              style: TextStyle(color: kLighterPurple, fontSize: 20),
            ),
          ],
          if (music != null) ...[
            Text(
              '${music!.title} - ${music!.artists.first.name}\n',
              style: const TextStyle(color: kLighterPurple, fontSize: 20),
            ),
            // Text(
            //   'Album: ${music!.album.name}\n',
            //   style: TextStyle(color: kLighterPurple, fontSize: 20),
            // ),
            // Text(
            //   'Artist: ${music!.artists.first.name}\n',
            //   style: TextStyle(color: kLighterPurple, fontSize: 20),
            // )
          ],
          const Spacer(),
          Center(
            child: GestureDetector(
                onTap: () async {
                  setState(() {
                    music = null;
                  });



                  final session = ACRCloud.startSession();
                  if (isActive == true) {
                    session.cancel;
                  }

                  isActive = isActive ? false : true;

                  final result = await session.result;

                  if (result == null) {
                    // Cancelled.
                    return;
                  } else if (result.metadata == null) {
                    setState(() {
                      isActive = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('No result.'),
                    ));
                    return;
                  }

                  setState(() {
                    music = result.metadata!.music.first;
                    isActive = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kLighterPurple,
                        Colors.white,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isActive == false
                      ? const Icon(
                          Icons.music_note_outlined,
                          size: 50,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.more_horiz,
                          size: 50,
                          color: Colors.white,
                        ),
                )),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
