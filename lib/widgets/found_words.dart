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
        // height: 80.0,
        child: ExpansionTile(
          title: Text('Found words'),
          children: [
            Container(
              height: 100,
              width: double.infinity,
              child: GridView.count(
                crossAxisCount: 3,
                children: foundWords.map((word) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(word),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}