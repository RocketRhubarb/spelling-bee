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

String formattedDate(DateTime date) {
  var formatter = new DateFormat('yyyyMMdd');
  String formDate = formatter.format(date);
  return formDate;
}

Future<DictionaryModel> fetchDictionary(DateTime date) async {
  // var date = '2021-07-27';

  String formDate = formattedDate(date);
  print(formDate);

  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');

  var store = StoreRef.main();

  var entry = await store.record(formDate).get(db) as Map;

  if (entry != null) {
    print('from db');
    print(entry['foundWords']);
    return DictionaryModel(
      words: List<String>.from(entry['words']),
      primaryLetter: entry['primaryLetter'],
      secondaryLetters: List<String>.from(entry['secondaryLetters']),
      foundWords: List<String>.from(entry['foundWords']),
    );
  } else {
    print('from web');
    var client = Client();
    var dictionary = await fetchAndCreateDictionary(client, formDate);
    storeInDb(dictionary, formDate);
    return dictionary;
  }
}

void storeInDb(DictionaryModel dictionary, String formDate) async {
  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');
  var store = StoreRef.main();

  await store.record(formDate).put(db, dictionary.toMap());
}

void updateFoundWords(DateTime date, List<String> foundWords) async {
  var formDate = formattedDate(date);

  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');
  var store = StoreRef.main();

  var record = store.record(formDate);
  // var readMap = await record.get(db);

  await record.update(db, {'foundWords': foundWords});

  // debug
  var entry = await store.record(formDate).get(db) as Map;
  print(entry['foundWords']);
}
