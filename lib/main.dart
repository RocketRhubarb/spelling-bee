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

  bool onlyShowWords = false;

  int score = 0;
  String word = '';
  List<String> foundWords = [];
  String message = '';

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
      word = word.substring(0, word.length - 1);
    });
  }

  void _checkWord() {
    setState(() {
      if (dictionary.contains(word)) {
        if (!foundWords.contains(word)) {
          foundWords.add(word);
          foundWords.sort();
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
      secondaryLetters.shuffle();
    });
  }

  int _calculateScore(word) {
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

  int get _maxScore {
    if (dictionary == null) {
      return 100;
    }

    return dictionary.map((element) {
      return _calculateScore(element);
    }).reduce((a, b) => a + b);
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
      });
    });
    print(_selectedDate);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Bee'),
      ),
      body: !onlyShowWords
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  onPressed: _datePicker,
                  child: Text(
                    '${DateFormat.yMMMd().format(_selectedDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: Theme.of(context).primaryColor,
                ),
                ScoreBoard(
                  score: score,
                  maximumScore: _maxScore,
                  level: getLevel,
                ),
                MediaQuery.of(context).size.height > 600
                    ? FoundWords(foundWords: foundWords)
                    : Column(
                        children: <Widget>[
                          Text('Show found words'),
                          Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: onlyShowWords,
                            onChanged: (value) {
                              setState(() {
                                onlyShowWords = value;
                              });
                            },
                          ),
                        ],
                      ),
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
            )
          : Column(
              children: <Widget>[
                Text('Show found words'),
                Switch(
                  value: onlyShowWords,
                  onChanged: (value) {
                    setState(() {
                      onlyShowWords = value;
                    });
                  },
                ),
                FoundWords(foundWords: foundWords)
              ],
            ),
    );
  }
}
