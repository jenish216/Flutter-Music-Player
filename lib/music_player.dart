import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import 'package:musicapp/globals.dart' as globals;

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  Function repeatTrack;

  final GlobalKey<MusicPlayerState> key;
  MusicPlayer({this.songInfo, this.changeTrack, this.key}) : super(key: key);
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = true;
  bool isShuffle = false;
  bool isRepeat = false;
  String codeDialog;
  String valueText;

  List<SongInfo> favSongs = [];

  // List<String> name=valueText;
  //final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
    getFavs();
    checkFav();
    getPlaylist();
  }

  void getFavs() {
    //songs = await audioQuery.getSongs();
    setState(() {
      favSongs = globals.favoriteSongs;
    });
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    checkFav();
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    if (mounted) {
      setState(() {
        currentTime = getDuration(currentValue);
        endTime = getDuration(maximumValue);
      });
    }
    isPlaying = false;
    changeStatus();

    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        // if (isRepeat == true && currentValue > maximumValue) {
        //   //currentValue = minimumValue;
        //   widget.repeatTrack();
        // } else
        if (currentValue > maximumValue) {
          widget.changeTrack(true, isShuffle);
        }
      });
    });
  }

  void checkFav() {
    if (favSongs.contains(widget.songInfo)) {
      setState(() {
        globals.isFav = true;
      });
    } else {
      setState(() {
        globals.isFav = false;
      });
    }
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  void changeRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
    if (isRepeat) {
      player.setLoopMode(LoopMode.one);
    } else {
      player.setLoopMode(LoopMode.off);
    }
  }

  void changeShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
  }

  getPlaylist() async {
    globals.playlist = await globals.audioQuery.getPlaylists();
  }

  Widget showAlertBox() {
    return Container(
        height: 100.0, // Change as per your requirement
        width: 100.0, // Change as per your requirement
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: globals.playlist.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(globals.playlist[index].name),
                );
              },
            ),
            TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text('Name'),
                        content: TextField(
                          onChanged: (value) {
                            setState(() {
                              valueText = value;
                            });
                          },
                          controller: TextEditingController(),
                          decoration: InputDecoration(hintText: "Enter Name"),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('CANCEL'),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ),
                          FlatButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            child: Text('OK'),
                            onPressed: () {
                              // globals.playlist[globals.playlist.length].name =
                              //     valueText;
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      );
                    }),
                child: Text("Create New"))
          ],
        ));
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white)),
        title: Text('Now Playing', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: Container(
          // color: Colors.black,
          decoration: new BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/songBg13.jpeg'),
                  fit: BoxFit.cover)),

          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(30, 90, 30, 0),
                  height: 350,
                  width: 500,
                  child: Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.darken),
                      image: widget.songInfo.albumArtwork == null
                          ? AssetImage('assets/images/default1.jpg')
                          : FileImage(File(widget.songInfo.albumArtwork)),
                      fit: BoxFit.cover,
                    ),
                    //border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    boxShadow: [
                      new BoxShadow(color: Colors.black, blurRadius: 25.0),
                    ],
                  ))),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  widget.songInfo.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 33),
                child: Text(
                  widget.songInfo.artist,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: IconButton(
                          icon: Icon(Icons.playlist_add, color: Colors.white),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Add to..'),
                                  content: showAlertBox(),
                                );
                              }),
                        ),
                      ),
                      GestureDetector(
                        child: Icon(
                          isRepeat ? Icons.repeat_one : Icons.repeat,
                          color: Colors.white,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          changeRepeat();
                        },
                      ),
                    ],
                  )),
              Slider(
                inactiveColor: Colors.white,
                activeColor: Colors.redAccent[400],
                min: minimumValue,
                max: maximumValue,
                value: currentValue,
                onChanged: (value) {
                  currentValue = value;
                  player.seek(Duration(milliseconds: currentValue.round()));
                },
              ),
              Container(
                transform: Matrix4.translationValues(0, -15, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentTime,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500)),
                    Text(endTime,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: Icon(
                            globals.isFav
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.red),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (globals.isFav) {
                            globals.favoriteSongs.remove(widget.songInfo);
                            checkFav();
                          } else {
                            globals.favoriteSongs.add(widget.songInfo);
                            checkFav();
                          }
                        }),
                    GestureDetector(
                      child: Icon(Icons.skip_previous,
                          color: Colors.white, size: 30),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // widget.changeTrack(false); //, isShuffle);
                        widget.changeTrack(false, isShuffle);
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled_sharp
                              : Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 70),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        changeStatus();
                      },
                    ),
                    GestureDetector(
                      child:
                          Icon(Icons.skip_next, color: Colors.white, size: 30),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // widget.changeTrack(true);
                        widget.changeTrack(true, isShuffle);
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                        isShuffle ? Icons.shuffle_on : Icons.shuffle,
                        color: Colors.white,
                      ),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        changeShuffle();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
