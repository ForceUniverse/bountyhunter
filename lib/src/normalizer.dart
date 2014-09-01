part of bountyhunter;

class Normalizer {
  
  static final Stemmer defaultStemmer = new PorterStemmer();
  
  Stemmer stemmer;
  
  Normalizer({this.stemmer}) {
    if (this.stemmer==null) this.stemmer = defaultStemmer;
  }
  
  String normalize(String word) {
    // first make it a lowercase word
    word = word.toLowerCase();
    // filter out punctuations & special chars
    word = word.replaceAll(new RegExp(r'[^\w\s]'), "");
    
    // stem this word
    stemmer.addWord(word);
    stemmer.stem();
    word = stemmer.toString();
    stemmer.reset();
    
    return word;
  }
  
}