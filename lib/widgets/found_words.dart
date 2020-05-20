import 'package:flutter/material.dart';

class FoundWords extends StatelessWidget {
  final List<String> foundWords;

  FoundWords({this.foundWords});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: Container(
        margin: EdgeInsets.all(7.0),
        width: double.infinity,
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your words:'),
            Text('$foundWords'),
          ],
        ),
      ),
    );
  }
}
