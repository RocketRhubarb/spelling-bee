import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Function checkWord;
  final Function removeLast;

  Buttons({this.checkWord, this.removeLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: RaisedButton(
                  onPressed: removeLast,
                  child: Text('DELETE'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: RaisedButton(
                  onPressed: checkWord,
                  child: Text('CHECK'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
