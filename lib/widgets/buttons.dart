import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Function checkWord;
  final Function removeLast;
  final Function shuffle;

  Buttons({this.checkWord, this.removeLast, this.shuffle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: RaisedButton(
                onPressed: removeLast,
                child: Text('DELETE'),
                color: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: Card(
                color: Theme.of(context).accentColor,
                shape: CircleBorder(),
                elevation: 2.0,
                child: IconButton(
                  icon: Icon(
                    Icons.autorenew,
                    color: Colors.black,
                  ),
                  onPressed: shuffle,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: RaisedButton(
                onPressed: checkWord,
                child: Text('CHECK'),
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
