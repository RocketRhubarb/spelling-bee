import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:spelling_bee/providers/fetch_from_web.dart' as fetch_from_web;

Future<void> main() {
  // Our tests will go here

  MockClient client = null;

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

  // print(await fetch_from_web.fetchWords(Client()));
}
