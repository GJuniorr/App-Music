import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:appmusic/Screens/32Andares.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favoriteSong extends StatefulWidget {
  const favoriteSong({super.key});

  @override
  State<favoriteSong> createState() => _favoriteSongState();
}

class _favoriteSongState extends State<favoriteSong> {

  late List<Song> playlist;

  AudioPlayer player = new AudioPlayer();

  List<int> songFavorite = [];
  List<Song> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    playlist = Classplaylist().playlist;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteStringList = prefs.getStringList('songFavorite');

    if (favoriteStringList != null) {
      setState(() {
        songFavorite = favoriteStringList.map((stringIndex) => int.parse(stringIndex)).toList();
        favoriteSongs = songFavorite.map((index) => Classplaylist().playlist[index]).toList();
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
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          Song song = favoriteSongs[index];
          return ListTile(
            title: Text(
              song.song,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song.artist,
              style: TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                 Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Andares(
                    player: player,
                    song: song.song,
                    artist: song.artist,
                    music: song.music,
                    currentIndex: index
                  )));
              },
            ),
          );
        },
      ),
    );
  }
}