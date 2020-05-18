import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int score;
  final int maximumScore;

  ScoreBoard({this.score, this.maximumScore});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 12.0,
            width: double.infinity,
            margin: EdgeInsets.all(7.0),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: score / maximumScore,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Level',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
