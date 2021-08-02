import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import './widgets/found_words.dart';
import './widgets/letter_tiles.dart';
import './widgets/score_board.dart';
import './widgets/buttons.dart';
import './models/dictionary_model.dart';
import './repository/resources.dart';
// import './repository/web_provider.dart';

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
  List<String> dictionary;
  String primaryLetter;
  List<String> secondaryLetters;
  DateTime _selectedDate;

  Future<DictionaryModel> dict;

  int score = 0;
  String word = '';
  String message = '';
  List<String> foundWords = [];

  @override
  void initState() {
    _selectedDate = DateTime.now();

    dict = fetchDictionary(_selectedDate);

    super.initState();
  }

  void _addToWord(String letter) {
    setState(() {
      word = word + letter;
    });
  }

  void _removeLast() {
    setState(() {
      if (word.length > 0) {
        word = word.substring(0, word.length - 1);
      }
    });
  }

  void _checkWord() {
    setState(() {
      if (dictionary == null) {
        return;
      }

      if (dictionary.contains(word)) {
        if (!foundWords.contains(word)) {
          foundWords.add(word);
          foundWords.sort();
          updateFoundWords(_selectedDate, foundWords);
          score += _calculateScore(word);
          message = '';
        }
      } else if (!word.contains(primaryLetter)) {
        message = 'Word must contain $primaryLetter';
      } else if (word.length < 4) {
        message = 'Word must contain four letters';
      } else if (!dictionary.contains(word)) {
        message = 'Not a valid word';
      }

      word = '';
    });
  }

  void _shuffleSecondaryLetterOrder() {
    setState(() {
      if (secondaryLetters == null) {
        return;
      }
      secondaryLetters.shuffle();
    });
  }

  int _calculateScore(String word) {
    if (secondaryLetters == null) return 1;

    bool panagram = secondaryLetters
        .map((element) => word.contains(element))
        .every((element) => element == true);

    if (panagram) {
      return word.length - 3 + 7;
    } else {
      return word.length - 3;
    }
  }

  int _calcualteTotalScore(List<String> words) {
    if (words.length == 0) {
      return 0;
    }
    return words
        .map((element) => _calculateScore(element))
        .reduce((a, b) => a + b);
  }

  int get _maxScore {
    if (dictionary == null) {
      return 100;
    }

    return _calcualteTotalScore(dictionary);
  }

  String get getLevel {
    if (score > _maxScore * 0.6) {
      return 'Expert';
    } else if (score > _maxScore * 0.5) {
      return 'Artisan';
    } else if (score > _maxScore * 0.4) {
      return 'Bookish';
    } else if (score > _maxScore * 0.2) {
      return 'Great';
    } else if (score > _maxScore * 0.1) {
      return 'On a roll';
    } else if (score > 10) {
      return 'Briliant';
    } else if (score > 2) {
      return 'Good Start';
    } else {
      return 'Beginner';
    }
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2019, 09, 01),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        dict = fetchDictionary(_selectedDate);
        // foundWords = [];
        score = _calcualteTotalScore(foundWords);
        getLevel;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Spelling Bee'),
            TextButton(
              onPressed: _datePicker,
              child: Text(
                '${DateFormat.yMMMd().format(_selectedDate)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                // primary: Theme.of(context).primaryColor,
                primary: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ScoreBoard(
            score: score,
            maximumScore: _maxScore,
            level: getLevel,
          ),
          FoundWords(foundWords: foundWords),
          Text(word, style: TextStyle(fontSize: 22.0)),
          Text(message),
          FutureBuilder<DictionaryModel>(
            future: dict, // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<DictionaryModel> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                dictionary = snapshot.data.words;
                primaryLetter = snapshot.data.primaryLetter;
                secondaryLetters = snapshot.data.secondaryLetters;
                foundWords = snapshot.data.foundWords;
                score = _calcualteTotalScore(foundWords);
                children = <Widget>[
                  LetterTiles(
                    primaryLetter: primaryLetter,
                    secondaryLetters: secondaryLetters,
                    addToWord: _addToWord,
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error.toString()}'),
                  )
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading today\'s puzzle'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
          Buttons(
            checkWord: _checkWord,
            removeLast: _removeLast,
            shuffle: _shuffleSecondaryLetterOrder,
          )
        ],
      ),
    );
  }
}
