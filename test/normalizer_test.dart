import 'package:unittest/unittest.dart';
import 'package:bountyhunter/bountyhunter.dart';

void main() {
  // First tests!
  test('test normalizer', () {
      String word = "Cool!";
      Normalizer normalizer = new Normalizer();
      
      word = normalizer.normalize(word);
      
      expect(word, "cool");
  });
  test('test special chars', () {
        String word = "Cool#";
        Normalizer normalizer = new Normalizer();
        
        word = normalizer.normalize(word);
        
        expect(word, "cool");
    });
  test('test stemmer', () {
          String word = "traditional";
          Normalizer normalizer = new Normalizer();
          
          word = normalizer.normalize(word);
          
          expect(word, "tradit");
      });
}