class DictionaryModel {
  final List<String> words;
  final String primaryLetter;
  List<String> secondaryLetters;

  DictionaryModel({this.words, this.primaryLetter, this.secondaryLetters});

  static DictionaryModel fromMap(Map<String, dynamic> map) {
    return DictionaryModel(
      words: map['words'],
      primaryLetter: map['primaryLetter'],
      secondaryLetters: map['secondaryLetters'],
    );
  }

  Map toMap() => {
        'words': words,
        'primaryLetter': primaryLetter,
        'secondaryLetters': secondaryLetters,
      };
}
