import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:spelling_bee/repository/web_provider.dart' as fetch_from_web;

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

    var response = await fetch_from_web.fetchWords(client, '20200202');

    // Assert
    expect(response, equals(['ABC', 'DEF', 'GHI']));
  });
  test('testing extract letter function', () {
    var words = ['ABC', 'ADE', 'AFG'];
    var letters = fetch_from_web.extractLetters(words);

    expect(letters['primaryLetter'], equals('A'));
    expect(letters['secondaryLetters'], equals(['B', 'C', 'D', 'E', 'F', 'G']));
  });
}
