import 'package:flutter/material.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final bool primary;
  final Function addToWord;

  LetterTile(
      {@required this.letter, this.primary = false, @required this.addToWord});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () {
            addToWord(letter);
          },
          child: Text(letter),
          color: primary
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
