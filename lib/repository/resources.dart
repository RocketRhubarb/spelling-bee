import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:intl/intl.dart';

import '../models/dictionary_model.dart';
import '../repository/web_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<DictionaryModel> fetchDictionary() async {
  var date = '2021-07-27';

  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');

  var store = StoreRef.main();

  var entry = await store.record(date).get(db) as Map;

  print(entry);

  if (entry != null) {
    print('from db');
    return DictionaryModel(
      words: List<String>.from(entry['words']),
      primaryLetter: entry['primaryLetter'],
      secondaryLetters: List<String>.from(entry['secondaryLetters']),
    );
  } else {
    print('from web');
    var client = Client();
    var dictionary = await fetchAndCreateDictionary(client);
    storeInDb(dictionary);
    return dictionary;
  }
}

void storeInDb(DictionaryModel dictionary) async {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);

  final path = await _localPath;
  print(path);
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');
  var store = StoreRef.main();

  await store.record(formattedDate).put(db, dictionary.toMap());
}
