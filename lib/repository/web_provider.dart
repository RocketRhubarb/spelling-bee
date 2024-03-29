import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

import 'package:spelling_bee/models/dictionary_model.dart';

Future<List<String>> fetchWords(Client client, String date) async {
  var url = 'https://nytbee.com/Bee_$date.html';
  Response response = await client.get(url);

  var document = parse(response.body);
  List<Element> links =
      document.querySelectorAll('#main-answer-list > ul > li');

  var words = links
      .map((link) => link.text)
      .map((word) => word.trim().toUpperCase())
      .toList();
  return words;
}

Map<String, dynamic> extractLetters(List<String> words) {
  Map<String, int> letterCount = {};

  void addToMap(letter) {
    if (!letterCount.containsKey(letter)) letterCount[letter] = 0;

    letterCount[letter] += 1;
  }

  words.forEach(
    (word) {
      word.split('').toSet().forEach(
        (letter) {
          addToMap(letter);
        },
      );
    },
  );
  // find the primary letter

  var nums = letterCount.values.toList();
  nums.sort((a, b) => a.compareTo(b));

  var primaryMap = Map<String, int>.from(letterCount);
  primaryMap.removeWhere((key, value) => value != nums.last);
  String primaryLetter = primaryMap.keys.toList()[0];

  var secondaryMap = Map<String, int>.from(letterCount);
  secondaryMap.removeWhere((key, value) => value == nums.last);
  List<String> secondaryLetter = secondaryMap.keys.toList();

  Map<String, dynamic> letters = {
    'primaryLetter': primaryLetter,
    'secondaryLetters': secondaryLetter,
  };

  return letters;
}

Future<DictionaryModel> fetchAndCreateDictionary(
    Client client, String date) async {
  var words = await fetchWords(client, date);

  if (words.length == 0) {
    return throw ("No found words today, pick other day.");
  }

  var letters = extractLetters(words);

  return DictionaryModel(
    words: words,
    primaryLetter: letters['primaryLetter'],
    secondaryLetters: letters['secondaryLetters'],
    foundWords: [],
  );
}
