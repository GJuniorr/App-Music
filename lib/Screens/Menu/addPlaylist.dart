import 'package:appmusic/Class/classPlaylist.dart';
import 'package:appmusic/Class/song.dart';
import 'package:appmusic/Screens/32Andares.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {

  bool addPlaylist = false;
  late List<Song> playlist;
  Map<int, bool> selectedSongs = {};
  Map<String, List<int>> allPlaylists = {};
  String playlistName = '';

  AudioPlayer player = new AudioPlayer();

  List<int> songPlaylist = [];
  List<Song> playlistSongs = [];

  @override
  void initState() {
    super.initState();
    playlist = Classplaylist().playlist;
    //loadPlaylist();
    //loadAllPlaylists();
  }

   @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

 Future<void> savePlaylist() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Verifique se o nome da playlist não está vazio

  List<int> selectedIndexes = selectedSongs.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  await prefs.setStringList('playlist_$playlistName', selectedIndexes.map((index) => index.toString()).toList());

  setState(() {
    allPlaylists['playlist_$playlistName'] = selectedIndexes;
  });
  print('Fui chamado');
}

  Future<void> loadAllPlaylists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> playlistKeys = prefs.getKeys();
  Map<String, List<int>> loadedPlaylists = {};

  for (String key in playlistKeys) {
    if (key.startsWith('playlist_')) {
      // Obtenha a lista de índices das músicas para esta playlist
      List<String>? songList = prefs.getStringList(key);
      if (songList != null) {
        try {
          // Converta a lista de índices para List<int>
          List<int> songIndexes = songList.map((index) => int.parse(index)).toList();
          loadedPlaylists[key] = songIndexes;
        } catch (e) {
          print('Erro ao converter índices de músicas para playlist: $e');
        }
      }
    }
  }

  setState(() {
    allPlaylists = loadedPlaylists;
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



  /*Future<void> savePlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> selectedIndexes = selectedSongs.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    await prefs.setStringList('songPlaylist', selectedIndexes.map((index) => index.toString()).toList());

    setState(() {
      songPlaylist = selectedIndexes;
      playlistSongs = selectedIndexes.map((index) => Classplaylist().playlist[index]).toList();
    });

    // Navegar para a tela de playlists ou fazer qualquer outra ação necessária
    Navigator.pushNamed(context, 'playlistSong');
  }*/
  
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'settings');
                    }, icon: Icon(Icons.settings,
                    color: Colors.white,),
                    ),
                    Text('Settings',
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
                  setState(() {
                    selectedSongs[index] = !(selectedSongs[index] ?? false);
                    //addPlaylist = !addPlaylist;
                  });
                  }, icon:  selectedSongs[index] ?? false ? Icon(Icons.check) : Icon(Icons.add))
              ],
            ),
            subtitle: 
                Text(song.artist,
                style: TextStyle(
                  color: Colors.white
                ),
                ),
          );
        },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: [
          BottomNavigationBarItem(
            icon:
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'playlistSong');
                  }, child: Text('Voltar',
                  style: TextStyle(
                    color: Colors.white
                  ),),
                  ),
                  label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('What name for playlist?',
                            textAlign: TextAlign.center,),
                            actions: [
                              Column(
                                children: [
                                  TextField(
                                    onChanged: (valueN) {
                                      setState(() {
                                        playlistName = valueN;
                                      });
                                      
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      labelText: 'Name for Playlist',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: Text('Back',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                    ),
                                    ),
                                   TextButton(
                                      onPressed: () {
                                        if (playlistName.isNotEmpty) {
                                          savePlaylist();
                                          Navigator.of(context).pop(); // Fechar o diálogo após salvar a playlist
                                        } else {
                                          // Você pode exibir uma mensagem de erro aqui se desejar
                                          print('Name for playlist cant empty');
                                        }
                                      }, child: Text('Create Playlist',
                                      style: TextStyle(
                                        color: Colors.black
                                      ),))
                                ],
                              )
                                ],
                              ),
                            ],
                          );
                        } ,);
                      savePlaylist();
                    }, child: Text('Criar playlist',
                    style: TextStyle(
                      color: Colors.white
                    ),),
                    ),
                    label: ''
                    ),
        ]
        ),
    );
  }
}