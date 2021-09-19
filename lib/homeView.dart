import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/album.dart';
import 'package:musicapp/favorites.dart';
import 'package:musicapp/globals.dart' as globals;

import 'package:flutter_audio_query/flutter_audio_query.dart';

import 'package:musicapp/tracks.dart';

List Title = [];
List Artist = [];
List<SongInfo> songs1 = [];

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Tracks(),
    Favorite(),
    Album(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.tealAccent,
        backgroundColor: Colors.blueGrey[800],
        height: 50,
        items: <Widget>[
          Icon(
            Icons.home,
          ),
          Icon(Icons.favorite),
          //Icon(Icons.album)
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
