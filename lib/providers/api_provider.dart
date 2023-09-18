import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/models/character_model.dart';
import 'package:rick_and_morty_app/models/episode_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final url = 'rickandmortyapi.com';
  List<Character> characters = [];
  List<Episode> episodes = [];

  Future<void> getCharacters(int page) async {
    final result = await http.get(Uri.https(url, '/api/character/', {
      'page': '$page',
    }));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }

  Future<List<Character>> getCharacter(String name) async {
    final result = await http.get(
      Uri.https(url, '/api/character/', {'name': name}),
    );
    final response = characterResponseFromJson(result.body);
    notifyListeners();
    return response.results!;
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (int i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = episodeResponseFromJson(result.body);
      episodes.add(response);
      notifyListeners();
    }

    return episodes;
  }
}
