import 'package:appmusic/Screens/32Andares.dart';
import 'package:appmusic/Screens/Menu/addPlaylist.dart';
import 'package:appmusic/Screens/Menu/favoriteSong.dart';
import 'package:appmusic/Screens/Menu/playlistSong.dart';
import 'package:appmusic/Screens/playlistReproduce.dart';
import 'package:appmusic/Screens/seePlaylists.dart';
import 'package:appmusic/homepage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      initialRoute: 'homepage',
      routes: {
        'homepage': (context) => Homepage(
          
        ),
        '32andares': (context) => Andares(
          player: AudioPlayer(),
          song: '',
          artist: '',
          music: '',
          currentIndex: 0,
        ),
        'favoriteSong': (context) => favoriteSong(

        ),
        'playlistSong': (context) => playlistSong(

        ),
        'addPlaylist': (context) => AddPlaylist(
          
        ),
        'seePlaylists': (context) => Seeplaylists(
          playlistName: '', 
          songIndexes: [

          ]
          ),
          'playlistReproduce': (context) => playlistReproduce(
            player: AudioPlayer(), 
            song: '', 
            artist: '', 
            music: '', 
            currentIndex: 0,
            playlistSongs: [

            ],
            ),
            
      },
    );
  }
}