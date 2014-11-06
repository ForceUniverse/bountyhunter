import 'package:unittest/unittest.dart';
import 'package:cargo/cargo_server.dart';
import 'package:bountyhunter/bountyhunter.dart';

void main() {
  // First tests!
  Cargo storage = new Cargo(MODE: CargoMode.MEMORY);

  storage.start().then((_) {
    // create a new instance of Hunter 
    Hunter hunter = new Hunter( storage );
    test('test basic search', () {
        hunter.feedDocSync("instruction set", "This is a small sentence with set architect");
        hunter.feedDocSync("data types", "What can we do?");
        hunter.feedDocSync("dartlang", "Just opensource!");
    
        // lets refeed instruction set!
        hunter.feedDocSync("instruction set", "Just refeed this instructions");
        
        List<Bounty> results = hunter.search("set architecture");
        
        expect(results.length, 0);
        // expect(results.first.name, "instruction set");
    });
  });
}