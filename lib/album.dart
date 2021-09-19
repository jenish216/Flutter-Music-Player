import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicapp/globals.dart' as globals;

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  List albumInfo = [];

  void initState() {
    super.initState();
    getAlbum();
  }

  void getAlbum() async {
    albumInfo = await globals.audioQuery
        .getAlbums(sortType: AlbumSortType.ALPHABETIC_ARTIST_NAME);
    if (mounted) {
      setState(() {
        albumInfo = albumInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      // 7body: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //     child: ListView.separated(
      //         separatorBuilder: (context, index) => Divider(),
      //         itemCount: albumInfo.length,
      //         itemBuilder: (context, index) => ListTile(
      //               leading: SizedBox(height: 32.0),

      // children: <Widget>[
      //   SizedBox(height: 32.0),
      //   CustomTextField(),
      //   SizedBox(height: 32.0),
      // Text(
      //   'Collections',
      //   style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 38.0),
      // ),
      //   SizedBox(height: 16.0),
      //   Row(
      //     children: <Widget>[
      //       ItemCard('s/images/songBg10.png', 'Extremely loud'),
      //       SizedBox(
      //         width: 16.0,
      //       ),
      //       ItemCard('assets/images/songBg11.jpeg', 'Calm & relaxing'),
      //     ],
      //   ),
      //   SizedBox(
      //     height: 32.0,
      //   ),
      //   Row(
      //     children: <Widget>[
      //       ItemCard('assets/images/songBg12.jpeg', 'Extremely loud'),
      //       SizedBox(
      //         width: 16.0,
      //       ),
      //       ItemCard('assets/images/songBg13.jpeg', 'Old Soul'),
      //     ],
      //   ),
      // ]
      // )
      // )
      // )
    );
  }
}

class ItemCard extends StatelessWidget {
  final image;
  final title;
  ItemCard(this.image, this.title);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120.0,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 140.0,
                      width: double.infinity,
                    )),
                Positioned(
                  right: 16.0,
                  top: 16.0,
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.white.withOpacity(0.6),
                    size: 24.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }
}
