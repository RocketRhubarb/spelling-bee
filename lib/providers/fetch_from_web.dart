import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

Future<List<String>> fetchWords(Client client) async {
  // var client = Client();
  Response response = await client.get('https://nytbee.com/');

  var document = parse(response.body);
  List<Element> links =
      document.querySelectorAll('#main-answer-list > ul > li');

  var words =
      links.map((link) => link.text).map((word) => word.trim()).toList();

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
