import 'dart:html';
import 'package:bountyhunter/bountyhunter.dart';
import 'package:cargo/cargo_client.dart';

Hunter hunter;
Cargo storage;

void main() {
  // initialize Bounty Hunter & Cargo
  storage = new Cargo(MODE: CargoMode.LOCAL);
  
  storage.start().then((_) {
      // create a new instance of Hunter 
      hunter = new Hunter( storage );
      
      querySelector("#btnFeed").onClick.listen(feedDocument);
      
      querySelector("#btnSearch").onClick.listen(searchDocument);
  });
}

void searchDocument(MouseEvent event) {
  InputElement txtSearch = querySelector("#txtSearch");
  
  List<Bounty> bounties = hunter.search(txtSearch.value);
  
  DivElement results = querySelector("#results");
  results.innerHtml = "";
  
  var docContent = storage.getItemSync("content", defaultValue: new Map());
  
  for (Bounty bounty in bounties) {
    results.appendHtml("<div style='font-weight: bold;'>${bounty.score} - ${bounty.name}</div>");
    var text = docContent[bounty.name];
    results.appendHtml("<div>${text}</div>");
  }
}

void feedDocument(MouseEvent event) {
  InputElement titleInput = querySelector("#titleInput");
  var title = titleInput.value;
  
  TextAreaElement docInput = querySelector("#docInput");
  var doc = docInput.value;
  
  hunter.feedDoc(title, doc);
  
  var docContent = storage.getItemSync("content", defaultValue: new Map());
  docContent[title] = doc;
  storage["content"] = docContent;
  
  // clear title and doc
  titleInput.value = "";
  docInput.value = "";
}
