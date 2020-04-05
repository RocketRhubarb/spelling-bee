import 'package:flutter/material.dart';

import './letter_tile.dart';

class LetterTiles extends StatelessWidget {
  final String primaryLetter;
  final List<String> secondaryLetters;
  final Function addToWord;

  LetterTiles({this.primaryLetter, this.secondaryLetters, this.addToWord});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LetterTile(letter: secondaryLetters[0], addToWord: addToWord),
            LetterTile(letter: secondaryLetters[1], addToWord: addToWord),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LetterTile(letter: secondaryLetters[2], addToWord: addToWord),
            LetterTile(
                letter: primaryLetter, addToWord: addToWord, primary: true),
            LetterTile(letter: secondaryLetters[3], addToWord: addToWord),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LetterTile(letter: secondaryLetters[4], addToWord: addToWord),
            LetterTile(letter: secondaryLetters[5], addToWord: addToWord),
          ],
        ),
      ],
    );
  }
}
