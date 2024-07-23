// ignore_for_file: file_names
import 'package:appmusic/Class/song.dart';
import 'package:flutter/material.dart';


class Classplaylist extends ChangeNotifier {
  final List<Song> _playlist = [
    
    // Song 1
    Song(
      song: '32 Andares',
      artist: 'Sos',
      music: '32andares.m4a'
    ),

    // Song 2
    Song(
      song: 'Se você Quiser',
      artist: 'Chris MC',
      music: 'SevcQuiser.m4a',
    ),

    // Song 3
    Song(
      song: 'Vida bela',
      artist: 'Primeiramente',
      music: 'VidaBela.m4a'
    ),

    // Song 4
    Song(
      song: 'Germiniano',
      artist: 'Djonga',
      music: 'Germiniano.m4a',
    )
  ];

  int? _currentSongIndex;


  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;

  set currentSongIndex(int? index) {
    _currentSongIndex = index;
    notifyListeners(); 
  }

   Future<void> nextSong() async {
    if(_currentSongIndex != null){
      if (_currentSongIndex! < _playlist.length - 1){
        currentSongIndex = _currentSongIndex! + 1;
      }
    }
  }
}