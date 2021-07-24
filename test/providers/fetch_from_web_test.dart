import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:spelling_bee/providers/fetch_from_web.dart' as fetch_from_web;

void main() {
  // Our tests will go here

  test('calling fetchWords(client) returns a list of words', () async {
    // Arrange

    var client = MockClient(
      (req) => Future(
        () => Response('''
        <body>
          <td class="title">
            <div id="main-answer-list">
              <ul>
              <li> abc </li>
              <li> def </li>
              <li> ghi </li>
              </ul>
            </div>
          </td>
        </body>
      ''', 200),
      ),
    );

    // Act

    var response = await fetch_from_web.fetchWords(client);

    // Assert
    expect(response, equals(['abc', 'def', 'ghi']));
  });
  test('testing extract letter function', () {
    var words = ['abc', 'ade', 'afg'];
    var letters = fetch_from_web.extractLetters(words);

    expect(letters['primaryLetter'], equals('a'));
    expect(letters['secondaryLetters'], equals(['b', 'c', 'd', 'e', 'f', 'g']));
  });
}
