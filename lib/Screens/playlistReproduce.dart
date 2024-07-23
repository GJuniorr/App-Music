// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/src/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class playlistReproduce extends StatefulWidget {
  final AudioPlayer? player;
  final String? song;
  final String? artist;
  final String? music;
  final int? currentIndex;
  final List<Song> playlistSongs;

  const playlistReproduce({
    super.key, 
    required this.player,
    required this.song,
    required this.artist,
    required this.music,
    required this.currentIndex,
    required this.playlistSongs,});

  @override
  State<playlistReproduce> createState() => _playlistReproduceState();
}

class _playlistReproduceState extends State<playlistReproduce> {

  List songFavorite = [];
  List songPlaylist = [];
  List<Song> get playlist => widget.playlistSongs;

  String? song;
  String? artist;
  String? music;
  bool favorite = false;
  bool playlistBool = false;

  Duration position = Duration.zero;

  Duration duration = Duration.zero;

  late StreamSubscription<Duration> durationSubscription;
  late StreamSubscription<Duration> positionSubscription;

  bool isPlaying = false;

  double volume = 1.0;

  int? currentSongIndex;

  
    @override
  void initState() {
    super.initState();
    loadFavorite();
    loadSongFavorites();
    loadPlaylist();
    loadSongPlaylist();
    song = widget.song;
    artist = widget.artist;
    music = widget.music;
    currentSongIndex = widget.currentIndex;
    
  
    durationSubscription = widget.player!.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    positionSubscription = widget.player!.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });

    widget.player!.setVolume(volume);
    _checkIfPlayingAndStop();
  }

   Future<void> _checkIfPlayingAndStop() async {
    
    if (await widget.player!.getCurrentPosition() != null) {
      await widget.player!.stop();
    }
  }

  // Save music for Playlist
  Future<void> savePlaylist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPlaylist = prefs.getBool('playlist_$currentSongIndex') ?? false;

  
  isPlaylist = !isPlaylist;

  if (isPlaylist == true){
    songPlaylist.add(currentSongIndex!);
  } else{
    songPlaylist.remove(currentSongIndex!);
  }
  await prefs.setStringList('songPlaylist', songPlaylist.map((index) => index.toString()).toList());

  
  await prefs.setBool('playlist_$currentSongIndex', isPlaylist);

  setState(() {
    playlistBool = isPlaylist;
  });
}
  // Load playlist Music
 Future<void> loadPlaylist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isPlaylist = prefs.getBool('playlist_$currentSongIndex') ?? false;

  setState(() {
    playlistBool = isPlaylist;
  });
}
  // Load list playlist Music
 Future<void> loadSongPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? playlistList = prefs.getStringList('songPlaylist');
    if (playlistList != null) {
      songPlaylist = playlistList.map((index) => int.parse(index)).toList();
    }
  }

  // Save favorite Music and Add favorite Music for List
 Future<void> saveFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFavorite = prefs.getBool('favorite_$currentSongIndex') ?? false;

  
  isFavorite = !isFavorite;

  if (isFavorite == true){
    songFavorite.add(currentSongIndex!);
  } else{
    songFavorite.remove(currentSongIndex!);
  }
  await prefs.setStringList('songFavorite', songFavorite.map((index) => index.toString()).toList());

  
  await prefs.setBool('favorite_$currentSongIndex', isFavorite);

  setState(() {
    favorite = isFavorite;
    
  });
}
  // Load favorite Music
 Future<void> loadFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFavorite = prefs.getBool('favorite_$currentSongIndex') ?? false;

  setState(() {
    favorite = isFavorite;
  });
}
  // Load list favorite Music
 Future<void> loadSongFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('songFavorite');
    if (favoriteList != null) {
      songFavorite = favoriteList.map((index) => int.parse(index)).toList();
    }
  }

 Future<void> nextSong() async {
  
  if (currentSongIndex != -1 && currentSongIndex! < playlist.length - 1) {
    Song nextSong = playlist[currentSongIndex! + 1];
    setState(() {
      currentSongIndex = currentSongIndex! + 1;
      song = nextSong.song;
      artist = nextSong.artist;
      music = nextSong.music;
    });
    await widget.player!.stop();
    await widget.player!.play(AssetSource(nextSong.music));
    setState(() {
      isPlaying = true;
      loadFavorite();
      loadSongFavorites();
      loadPlaylist();
      loadSongPlaylist();
      
    });
  }
  else {
    Song firstSong = playlist[0];
    setState(() {
      currentSongIndex = 0;
      song = firstSong.song;
      artist = firstSong.artist;
      music = firstSong.music;
    });
    await widget.player!.stop();
    await widget.player!.play(AssetSource(firstSong.music));
    setState(() {
      isPlaying = true;
      loadFavorite();
      loadSongFavorites();
      loadPlaylist();
      loadSongPlaylist();
    });
  }
}

Future<void> previousSong() async {
  if (currentSongIndex != null) {
    if (currentSongIndex! > 0) {
      Song previousSong = playlist[currentSongIndex! - 1];
      setState(() {
        currentSongIndex = currentSongIndex! - 1;
        song = previousSong.song;
        artist = previousSong.artist;
        music = previousSong.music;
      });
      await widget.player!.stop();
      await widget.player!.play(AssetSource(previousSong.music));
      setState(() {
        isPlaying = true;
        loadFavorite();
        loadSongFavorites();
        loadPlaylist();
        loadSongPlaylist();
      });
    } else {
      
      Song lastSong = playlist[playlist.length - 1];
      setState(() {
        currentSongIndex = playlist.length - 1;
        song = lastSong.song;
        artist = lastSong.artist;
        music = lastSong.music;
      });
      await widget.player!.stop();
      await widget.player!.play(AssetSource(lastSong.music));
      setState(() {
        isPlaying = true;
        loadFavorite();
        loadSongFavorites();
        loadPlaylist();
        loadSongPlaylist();
      });
    }
  }
}

  @override
  void dispose() {
    widget.player!.stop();
    durationSubscription.cancel();
    positionSubscription.cancel();
    super.dispose();
  }

   Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await widget.player!.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      
      await widget.player!.stop();
      await widget.player!.play(AssetSource(widget.music!));
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MusicApp',
        style: TextStyle(
          color: Colors.white
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'homepage');
                    }, icon: Icon(Icons.home,
                    color: Colors.white,),
                    ),
                    Text('Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),),
                ],
              ),
            ),
             Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'favoriteSong');
                    }, icon: Icon(Icons.favorite,
                    color: Colors.white,),
                    ),
                    Text('Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),),
                ],
              ),
               Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'playlistSong');
                    }, icon: Icon(Icons.queue_music,
                    color: Colors.white,),
                    ),
                    Text('Playlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),),
                ],
              ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 200,
              height: 200,
              color: Colors.grey,
              child: Icon(Icons.music_note,
              size: 100,),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${artist} - ${song!}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      //favorite = !favorite;
                      saveFavorite();
                    });
                  }, icon: favorite ? Icon(Icons.favorite,
                  color: Colors.red,)
                  : Icon(Icons.favorite_border,
                  color: Colors.white,),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        savePlaylist();
                      });
                    }, icon: playlistBool ? Icon(Icons.bookmark,
                    color: Colors.white,)
                    : Icon(Icons.bookmark_outline,
                    color: Colors.white,))
              ],
            ),
          ),
          Slider(
              value: position.inSeconds.toDouble(),
              onChanged: (double value) async {
                final CurrentPosition = Duration(seconds: value.toInt());
                await widget.player!.seek(CurrentPosition);
                setState(() {
                  position = CurrentPosition;
                });
              },
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              divisions: duration.inSeconds > 0 ? duration.inSeconds : 1,
              label: position.toString().split('.').first,
              activeColor: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      previousSong();
                    });
                  }, icon: Icon(Icons.keyboard_double_arrow_left,
                  size: 25,
                  color: Colors.white,),
                  ),
                  IconButton(
                  onPressed: () {
                    _togglePlayPause();
                  },icon: isPlaying ? Icon(Icons.pause,
                  size: 25,
                  color: Colors.white,) : Icon(Icons.play_arrow,
                  size: 25,
                  color: Colors.white,),
                  ),
                  IconButton(
                  onPressed: () {
                    setState(() {
                      nextSong();
                    });
                  }, icon: Icon(Icons.keyboard_double_arrow_right,
                  size: 25,
                  color: Colors.white,),
                  ),
              ],
            ),
          ],
      ),
    );
  }
}