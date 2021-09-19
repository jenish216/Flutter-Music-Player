import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicapp/music_player.dart';
import 'package:musicapp/globals.dart' as globals;

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> favSongs = [];

  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  void initState() {
    super.initState();
    getFavs();
  }

  void getFavs() {
    //songs = await audioQuery.getSongs();
    if (mounted) {
      setState(() {
        favSongs = globals.favoriteSongs;
      });
    }
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != favSongs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(favSongs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   leading: Icon(Icons.music_note, color: Colors.white),
      //   title: Text('Music Player', style: TextStyle(color: Colors.white)),
      // ),
      appBar: AppBar(
        titleSpacing: 50,
        title: Text(
          'Favourite Songs',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.tealAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        // decoration: new BoxDecoration(
        //     image: new DecorationImage(
        //         image: AssetImage('assets/images/listview1.jpg'),
        //         fit: BoxFit.fill)),
        child: ListView.builder(
            itemCount: favSongs.length,
            itemBuilder: (context, index) {
              return SizedBox(
                  width: 200,
                  height: 100,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    // shape: BeveledRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.blueGrey[800],
                    shadowColor: Colors.blue[700],
                    elevation: 10,

                    child: ListTile(
                      minVerticalPadding: 30,
                      leading: CircleAvatar(
                        backgroundImage: favSongs[index].albumArtwork == null
                            ? AssetImage('assets/images/default1.jpg')
                            : FileImage(File(favSongs[index].albumArtwork)),
                        radius: 25,
                      ),
                      title: Text(favSongs[index].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),

                      // subtitle: Text(songs[index].artist,
                      //     style: TextStyle(color: Colors.white)),
                      onTap: () {
                        currentIndex = index;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MusicPlayer(
                                changeTrack: changeTrack,
                                songInfo: favSongs[currentIndex],
                                key: key)));
                      },
                    ),
                  ));
            }),
      ),
    );
  }
}
