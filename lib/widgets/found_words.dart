import 'package:flutter/material.dart';

class FoundWords extends StatelessWidget {
  final List<String> foundWords;

  FoundWords({this.foundWords});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 15.0, left: 15.0),
      child: Container(
        margin: EdgeInsets.only(right: 7.0, left: 7.0),
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
                childAspectRatio: 4.0,
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
