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

Future<DictionaryModel> fetchDictionary(DateTime date) async {
  // var date = '2021-07-27';

  var formatter = new DateFormat('yyyyMMdd');
  String formattedDate = formatter.format(date);

  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');

  var store = StoreRef.main();

  var entry = await store.record(formattedDate).get(db) as Map;

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
    var dictionary = await fetchAndCreateDictionary(client, formattedDate);
    storeInDb(dictionary, formattedDate);
    return dictionary;
  }
}

void storeInDb(DictionaryModel dictionary, String formattedDate) async {
  final path = await _localPath;
  final db = await databaseFactoryIo.openDatabase('$path/words_and_letters.db');
  var store = StoreRef.main();

  await store.record(formattedDate).put(db, dictionary.toMap());
}
