import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_border.dart';

class LetterTile extends StatelessWidget {
  final String letter;
  final bool primary;
  final Function addToWord;

  LetterTile(
      {@required this.letter, this.primary = false, @required this.addToWord});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          addToWord(letter);
        },
        child: Padding(
          padding: EdgeInsets.all(35),
          child: Text(
            letter,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        color: primary
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColorLight,
        shape: PolygonBorder(
          sides: 6,
          borderRadius: 5.0,
        ),
      ),
    );
  }
}
