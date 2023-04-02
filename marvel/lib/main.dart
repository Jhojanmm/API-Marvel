import 'package:marvel/getPersonajes.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personajes de Marvel',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MarvelCharacters(),
    );
  }
}

class MarvelCharacters extends StatefulWidget {
  @override
  _MarvelCharactersState createState() => _MarvelCharactersState();
}

class _MarvelCharactersState extends State<MarvelCharacters> {
  late Future<Map<String, dynamic>> _futureMarvelData;

  @override
  void initState() {
    super.initState();
    _futureMarvelData = getMarvelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes de Marvel'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureMarvelData,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<dynamic> characters = snapshot.data?['data']['results'] ?? [];
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (BuildContext context, int index) {
              final character = characters[index];
              final String imageUrl =
                  '${character['thumbnail']['path']}.${character['thumbnail']['extension']}';
              return Card(
                child: ListTile(
                  leading: Image.network(imageUrl),
                  title: Text(character['name']),
                  subtitle: Text(character['description'] ?? 'No description available.'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CharacterDetails(character: character)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CharacterDetails extends StatelessWidget {
  final dynamic character;

  const CharacterDetails({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageUrl = '${character['thumbnail']['path']}.${character['thumbnail']['extension']}';
    return Scaffold(
      appBar: AppBar(
        title: Text(character['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(imageUrl),
              SizedBox(height: 16.0),
              Text(character['description'] ?? 'Descripción no disponible')
            ],
          ),
        ),
      ),
    );
  }
}
