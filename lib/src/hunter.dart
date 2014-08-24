part of bountyhunter;

class Hunter {
  
  static String LATEST_DOCID = "latest_docId";
  
  CargoBase cargo;
  Configuration configuration = new Configuration();
  
  Hunter(this.cargo);
  
  int feedDoc(String key, String unstructuredDoc) {
    // lookup if doc already exist!
    if (cargo["docs"]==null) {
      cargo.setItem("docs", new Map());
      cargo.setItem("docIds", new Map());
    }
    // reverse index
    if (cargo["index"]==null) {
      cargo["index"] = new Map();
    }
    
    var docInfo = cargo["docs"][key];
    
    int docId;
    if (docInfo==null) {
      // put docId info into persistence
      docId = _latestDocId();
      cargo["docs"][key] = docId;
      cargo["docIds"][docId] = key; 
    } else {
      docId = docInfo;
      
      // docId already exist so clear the document in the index before re-indexing the new document
      Map index = cargo["index"];
      index.forEach((key, value) {
        if (value is Set) {
          Set postings = value;
          postings.remove(docId);
        }
      });
    }
    
    
    unstructuredDoc.split(" ").forEach((word) {
      if (!configuration.skipWord(word)) {
        Set wordSet = cargo["index"][word];
        if (wordSet==null) {
          wordSet = new Set();
        }
  
        wordSet.add(docId);
        cargo["index"][word] = wordSet;
      }
    });
    
    return docId;
  }
  
  List<Bounty> search(String sentence) {
    List<Bounty> findDocs = new List();
    if (cargo["index"]!=null) {
      Set docIdsRetrieval;
      for (String term in sentence.split(" ")) {
        if (cargo["index"][term]!=null && !configuration.skipWord(term)) {
          if (docIdsRetrieval==null) {
            docIdsRetrieval = cargo["index"][term];
          } else {
            docIdsRetrieval = docIdsRetrieval.intersection(cargo["index"][term]);
          }
        }
      }
      
      for (var docId in docIdsRetrieval) {
        findDocs.add(new Bounty(1.0, docId, cargo["docIds"][docId]));
      }
    }
    return findDocs;
  }
  
  int _latestDocId() {
    int latestDocId = cargo[LATEST_DOCID];
    if (latestDocId==null) {
      cargo[LATEST_DOCID] = 0;
      latestDocId = 0;
    } else {
      cargo[LATEST_DOCID]++;
    }
    return latestDocId;
  }
  
}