part of bountyhunter;

class Normalizer {
  
  String normalize(String word) {
    // first make it a lowercase word
    word = word.toLowerCase();
    // filter out punctuations & special chars
    word = word.replaceAll(new RegExp(r'[^\w\s]'), "");
    return word;
  }
  
}