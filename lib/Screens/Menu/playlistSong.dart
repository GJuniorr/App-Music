import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:appmusic/Screens/32Andares.dart';
import 'package:appmusic/Screens/seePlaylists.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class playlistSong extends StatefulWidget {
  const playlistSong({super.key});

  @override
  State<playlistSong> createState() => _playlistSongState();
}

class _playlistSongState extends State<playlistSong> {

  Map<String, List<int>> allPlaylists = {};
  List<String> playlistNames = [];

  late List<Song> playlist;

  AudioPlayer player = new AudioPlayer();

  List<int> songPlaylist = [];
  List<Song> playlistSongs = [];

  @override
  void initState() {
    super.initState();
    playlist = Classplaylist().playlist;
    //loadPlaylist();
    loadAllPlaylists();
  }

   @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> loadAllPlaylists() async {
  // Obtém uma instância do SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Obtém todas as chaves armazenadas no SharedPreferences
  Set<String> playlistKeys = prefs.getKeys();
  
  // Cria um mapa para armazenar playlists carregadas
  Map<String, List<int>> loadedPlaylists = {};

  // Itera sobre todas as chaves
  for (String key in playlistKeys) {
    if (key.startsWith('playlist_')) {
      // Obtém a lista de índices de músicas (strings) associada à chave
      List<String>? songList = prefs.getStringList('playlist_');

      if (songList != null) {
        try {
          // Converte a lista de índices (strings) para uma lista de inteiros
          List<int> songIndexes = songList.map((index) => int.parse(index)).toList();
          // Adiciona a playlist carregada ao mapa
          loadedPlaylists[key] = songIndexes;
        } catch (e) {
          print('Erro ao converter índices de músicas para playlist: $e');
        }
      } else {
        print('Nenhuma lista de músicas encontrada para a chave $key');
      }
    }
  }

  // Atualiza o estado do widget com as playlists carregadas
  setState(() {
    allPlaylists = loadedPlaylists;
    playlistNames = loadedPlaylists.keys.toList();
  });
}

  Future<void> loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteStringList = prefs.getStringList('playlist_');

    if (favoriteStringList != null) {
      setState(() {
        songPlaylist = favoriteStringList.map((stringIndex) => int.parse(stringIndex)).toList();
        playlistSongs = songPlaylist.map((index) => Classplaylist().playlist[index]).toList();
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
            padding: const EdgeInsets.only(left: 360.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addPlaylist');
                }, icon: Icon(Icons.add)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: playlistNames.length,
              itemBuilder: (context, index) {
                final playlistName = playlistNames[index];
                return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    playlistName.replaceFirst('playlist_', ''),
                    style: TextStyle(color: Colors.white),
                      ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {
                    player.stop();
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Seeplaylists(
                      playlistName: playlistName,
                      songIndexes: allPlaylists[playlistName]!,
                    )));
                    }, icon: Icon(Icons.play_arrow))
                ],
              ),
            );
              },),
          )
        ],
      )
    );
  }
}

