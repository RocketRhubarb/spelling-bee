class DictionaryModel {
  final List<String> words;
  final String primaryLetter;
  List<String> secondaryLetters;
  List<String> foundWords;

  DictionaryModel(
      {this.words, this.primaryLetter, this.secondaryLetters, this.foundWords});

  static DictionaryModel fromMap(Map<String, dynamic> map) {
    return DictionaryModel(
      words: map['words'],
      primaryLetter: map['primaryLetter'],
      secondaryLetters: map['secondaryLetters'],
      foundWords: map['foundWords'],
    );
  }

  Map toMap() => {
        'words': words,
        'primaryLetter': primaryLetter,
        'secondaryLetters': secondaryLetters,
        'foundWords': foundWords,
      };
}
