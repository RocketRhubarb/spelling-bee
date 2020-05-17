import 'package:flutter/material.dart';

import './widgets/letter_tiles.dart';
import './widgets/score_board.dart';
import './widgets/buttons.dart';
import './words_and_letters.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.grey[200],
      ),
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

  List<String> foundWords = [];
  String message = '';

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

  void _shuffleSecondaryLetterOrder() {
    setState(() {
      secondaryLetters.shuffle();
    });
  }

  int get maxScore {
    return dictionary.map((element) {
      return element.length;
    }).reduce((a, b) => a + b);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Bee'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ScoreBoard(score: score, maximumScore: maxScore),
            Container(
              child: Column(
                children: <Widget>[Text('Found words:'), Text('$foundWords')],
              ),
            ),
            Container(
              child: Text(word, style: TextStyle(fontSize: 22.0)),
            ),
            Container(child: Text(message)),
            LetterTiles(
              primaryLetter: primaryLetter,
              secondaryLetters: secondaryLetters,
              addToWord: _addToWord,
            ),
            Buttons(
              checkWord: _checkWord,
              removeLast: _removeLast,
              shuffle: _shuffleSecondaryLetterOrder,
            )
          ],
        ),
      ),
    );
  }
}
