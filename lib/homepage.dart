import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:appmusic/Screens/32Andares.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {

  const Homepage({
    super.key,});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  late List<Song> playlist;

  AudioPlayer player = new AudioPlayer();

  bool isPlaying = false;

  

    @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    playlist = Classplaylist().playlist;
    super.initState();
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
        itemCount: playlist.length,
        itemBuilder: (context, index) {
          final Song song = playlist[index];
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(song.song,
                style: TextStyle(
                  color: Colors.white
                ),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                  player.stop();
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Andares(
                    player: player,
                    song: song.song,
                    artist: song.artist,
                    music: song.music,
                    currentIndex: index
                    
                  )));
                  }, icon: Icon(Icons.play_arrow))
              ],
            ),
            subtitle: 
                Text(song.artist,
                style: TextStyle(
                  color: Colors.white
                ),
                ),
          );
        },),
    );
  }
}