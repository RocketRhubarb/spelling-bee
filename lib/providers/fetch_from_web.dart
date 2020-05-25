import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

Future<List<String>> fetchWords(Client client) async {
  // var client = Client();
  Response response = await client.get('https://nytbee.com/');

  var document = parse(response.body);
  List<Element> links =
      document.querySelectorAll('#main-answer-list > ul > li');

  var words =
      links.map((link) => link.text).map((word) => word.trim()).toList();

  return words;
}
