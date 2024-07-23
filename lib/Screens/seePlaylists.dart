import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:appmusic/Screens/32Andares.dart';
import 'package:appmusic/Screens/playlistReproduce.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Seeplaylists extends StatefulWidget {

  final String playlistName;
  final List<int> songIndexes;

  const Seeplaylists({
    required this.playlistName,
    required this.songIndexes,
    super.key});

  @override
  State<Seeplaylists> createState() => _SeeplaylistsState();
}

class _SeeplaylistsState extends State<Seeplaylists> {
  late List<Song> playlist;
  late List<Song> playlistSongs;
  AudioPlayer player = new AudioPlayer();


  @override
  void initState() {
    super.initState();
    playlist = Classplaylist().playlist;
    playlistSongs = widget.songIndexes.map((index) => playlist[index]).toList();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName.replaceFirst('playlist_', '')),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: playlistSongs.length,
        itemBuilder: (context, index) {
          final Song song = playlistSongs[index];
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  song.song,
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    player.stop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => playlistReproduce(
                    player: player,
                    song: song.song,
                    artist: song.artist,
                    music: song.music,
                    currentIndex: index,
                    playlistSongs: playlistSongs,
                  )));
                    // Navegar para uma tela de reprodução se necessário
                  },
                  icon: Icon(Icons.play_arrow),
                ),
              ],
            ),
            subtitle: Text(
              song.artist,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}