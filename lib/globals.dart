library musicapp.globals;

import 'dart:ui';

import 'package:flutter_audio_query/flutter_audio_query.dart';

List<SongInfo> favoriteSongs = [];
bool isFav = false;
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

List<PlaylistInfo> playlist = [];
