part of bountyhunter;

class Configuration {
  
  List<String> stopWords;
  
  Configuration() {
    stopWords = new List<String>(); 
  }
  
  Configuration.fromList(this.stopWords);
  
  bool skipWord(String word) {
    return stopWords.contains(word);
  }
}