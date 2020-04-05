import 'package:flutter/material.dart';
import 'package:spelling_bee/widgets/letter_tiles.dart';

import './widgets/buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int score = 0;
  String word = '';
  List<String> dictionary = [
    'dildo',
    'dill',
    'diploid',
    'doll',
    'dollop',
    'dolphin',
    'hill',
    'hold',
    'idol',
    'lion',
    'lipid',
    'lipo',
    'lipoid',
    'loin',
    'loll',
    'lollipop',
    'lollop',
    'loon',
    'loop',
    'nonillion',
    'olio',
    'pill',
    'pillion',
    'plod',
    'plop',
    'polio',
    'poll',
    'polo',
    'pool',
    'poplin',
  ];

  List<String> foundWords = [];
  String primaryLetter = 'L';
  List<String> secondaryLetters = ['D', 'P', 'O', 'N', 'I', 'H'];
  String message = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Bee'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            showScore(),
            showFoundWords(),
            showWord(),
            showMessage(),
            LetterTiles(
              primaryLetter: primaryLetter,
              secondaryLetters: secondaryLetters,
              addToWord: _addToWord,
            ),
            Buttons(
              checkWord: _checkWord,
              removeLast: _removeLast,
            )
          ],
        ),
      ),
    );
  }

  Widget showScore() {
    return Container(
      child: Text(
        'Score: $score',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }

  Widget showFoundWords() {
    return Container(
      child: Column(
        children: <Widget>[Text('Found words:'), Text('$foundWords')],
      ),
    );
  }

  Widget showWord() {
    return Container(
      child: Text(word, style: TextStyle(fontSize: 22.0)),
    );
  }

  Widget showMessage() {
    return Container(child: Text(message));
  }

  void _addToWord(String letter) {
    setState(() {
      word = word + letter;
    });
  }

  void _removeLast() {
    setState(() {
      word = word.substring(0, word.length - 1);
    });
  }

  void _checkWord() {
    setState(() {
      if (dictionary.contains(word.toLowerCase())) {
        if (!foundWords.contains(word)) {
          foundWords.add(word);
          score += word.length;
          message = '';
        }
      } else if (!word.contains(primaryLetter)) {
        message = 'Word must contain $primaryLetter';
      } else if (word.length < 4) {
        message = 'Word must contain four letters';
      }

      word = '';
    });
  }
}
