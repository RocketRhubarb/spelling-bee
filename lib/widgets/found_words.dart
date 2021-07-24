import 'package:flutter/material.dart';

class FoundWords extends StatelessWidget {
  final List<String> foundWords;

  FoundWords({this.foundWords});

  int calcualateCrossAxisWordCount(BuildContext context) {
    return (MediaQuery.of(context).size.width ~/ 140).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 15.0, left: 15.0),
      child: Container(
        margin: EdgeInsets.only(right: 7.0, left: 7.0),
        width: double.infinity,
        child: ExpansionTile(
          title: Text('Found words'),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: double.infinity,
              // child: Wrap(
              //   spacing: 8.0,
              //   runSpacing: 4.0,
              //   children: foundWords.map((word) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         word,
              //         textAlign: TextAlign.center,
              //       ),
              //     );
              //   }).toList(),
              // ),
              child: GridView.count(
                crossAxisCount: calcualateCrossAxisWordCount(context),
                childAspectRatio: 4.5,
                children: foundWords.map((word) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      word,
                      textAlign: TextAlign.center,
                    ),
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
