import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicapp/music_player.dart';
import 'package:musicapp/globals.dart' as globals;
import 'package:simple_search_bar/simple_search_bar.dart';

class Tracks extends StatefulWidget {
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  // final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final AppBarController appBarController = AppBarController();
  List<SongInfo> songs = [];
  List<SongInfo> favSongs = [];
  int currentIndex = 0;
  Random random = new Random();
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  void initState() {
    super.initState();
    getTracks();
    getFavs();
    //checkFav();
  }

  void getTracks() async {
    songs = await globals.audioQuery.getSongs();
    if (mounted) {
      setState(() {
        songs = songs;
      });
    }
  }

  void getFavs() {
    //songs = await audioQuery.getSongs();

    setState(() {
      favSongs = globals.favoriteSongs;
    });
  }

  // void checkFav() {
  //   if (favSongs.contains(widget.songInfo)) {
  //     setState(() {
  //       globals.isFav = true;
  //     });
  //   } else {
  //     setState(() {
  //       globals.isFav = false;
  //     });
  //   }
  // }

  // void repeatTrack() {
  //   currentIndex--;
  //   key.currentState.setSong(songs[currentIndex]);
  // }

  void changeTrack(bool isNext, bool isShuffle) {
    if (isNext && isShuffle) {
      currentIndex = random.nextInt(songs.length - 1);
    } else if (isNext && !isShuffle) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

  // void shuffle(bool isShuffle) {}

  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.grey[600],
      extendBodyBehindAppBar: true,
      //globals.blueColor,
      appBar:
          // SearchAppBar(
          //   primary: Theme.of(context).primaryColor,
          //   appBarController: appBarController,
          //   // You could load the bar with search already active
          //   autoSelected: true,
          //   searchHint: "Enter song name",

          //   mainTextColor: Colors.white,
          //   onChange: (String value) async {
          //     //Your function to filter list. It should interact with
          //     //the Stream that generate the final list

          //     //showSearch(context: context, delegate: DataSearch());
          //   },
          //mainAppBar:
          AppBar(
        titleSpacing: 50,
        title: Text(
          'All Tracks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: <Widget>[
        //   Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: InkWell(
        //         child: Icon(
        //           Icons.search,
        //           color: Colors.black,
        //         ),
        //         onTap: () {
        //           appBarController.stream.add(true);
        //         },
        //       ))
        // ],
        backgroundColor: Colors.tealAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),

      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(

            // separatorBuilder: (context, index) => Divider(
            //   height: 30,
            //   indent: 20,
            //   endIndent: 20,
            //   color: Colors.white,
            // ),

            itemCount: songs.length,
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
                        backgroundImage: songs[index].albumArtwork == null
                            ? AssetImage('assets/images/default1.jpg')
                            : FileImage(File(songs[index].albumArtwork)),
                        radius: 25,
                      ),
                      title: Text(songs[index].title,
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
                                songInfo: songs[currentIndex],
                                key: key)));
                      },
                    ),
                  ));
            }),
      ),
    );
  }
}

// class DataSearch extends SearchDelegate<String> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = " ";
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Container(
//         height: 100.0,
//         width: 100.0,
//         child: Card(
//           color: Colors.red,
//           child: Center(child: Text(query)),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {}
// }
