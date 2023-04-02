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
                  subtitle: Text(character['description'].isNotEmpty ? character['description'] : 'Descripción no disponible.'),
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
              Text(character['description'].isNotEmpty ? character['description'] : 'Descripción no disponible.'),
              SizedBox(height: 16.0),
              Text('Comics: ${character['comics']['available']}'),
              SizedBox(height: 16.0),
              Text('Series: ${character['series']['available']}'),
              SizedBox(height: 16.0),
              Text('Events: ${character['events']['available']}'),
              SizedBox(height: 16.0),
              Text('Stories: ${character['stories']['available']}'),
              SizedBox(height: 16.0),
              Text('Top 1: ${character['series']['items'].isNotEmpty ? character['series']['items'][0]['name'] : 'No disponible'}'),
              SizedBox(height: 16.0),
              Text('Top 2: ${character['series']['items'].length > 1 ? character['series']['items'][1]['name'] : 'No disponible'}'),
              SizedBox(height: 16.0),
              Text('Top 3: ${character['series']['items'].length > 2 ? character['series']['items'][2]['name'] : 'No disponible'}'),              

            ],
          ),
        ),
      ),
    );
  }
}