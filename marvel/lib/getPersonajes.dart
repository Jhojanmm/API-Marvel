import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMarvelData() async {
  final String url = 'https://gateway.marvel.com/v1/public/characters?ts=4&apikey=b29bfdf209cc79cbfa3f6bf2a688b195&hash=40892d6bc4976621c6969f6b0001f685';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load data');
  }
}

