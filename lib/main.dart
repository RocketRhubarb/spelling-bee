import 'package:flutter/material.dart';

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
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            showScore(),
            Padding(padding: EdgeInsets.all(10)),
            showFoundWords(),
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
              flex: 1,
              child: showWord(),
            ),
            tiles(),
            showMessage(),
            Padding(padding: EdgeInsets.all(10)),
            buttons(),
            Padding(padding: EdgeInsets.all(20)),
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

  Widget tiles() {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          tile(secondaryLetters[0]),
          tile(secondaryLetters[1]),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          tile(secondaryLetters[2]),
          tile(primaryLetter, primary: true),
          tile(secondaryLetters[3]),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          tile(secondaryLetters[4]),
          tile(secondaryLetters[5]),
        ],
      ),
    ]);
  }

  Widget tile(String letter, {bool primary = false}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            _addToWord(letter);
          },
          child: Text(letter),
          color: primary ? Colors.amber[400] : Colors.grey[200],
        ),
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

  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: deleteButton(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: checkButton(),
        ),
      ],
    );
  }

  Widget deleteButton() {
    return Container(
        child: RaisedButton(
      onPressed: () {
        setState(() {
          word = word.substring(0, word.length - 1);
        });
      },
      child: Text('DELETE'),
    ));
  }

  Widget checkButton() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          _checkWord();
        },
        child: Text('CHECK'),
      ),
    );
  }

  void _addToWord(String letter) {
    setState(() {
      word = word + letter;
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
