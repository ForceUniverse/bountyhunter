part of bountyhunter;

class Hunter {
  
  static String LATEST_DOCID = "latest_docId";
  
  CargoBase cargo;
  
  Hunter(this.cargo);
  
  int feedDoc(String key, String unstructuredDoc) {
    // lookup if doc already exist!
    if (cargo["docs"]==null) {
      cargo.setItem("docs", new Map());
      cargo.setItem("docIds", new Map());
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
    }
    
    // reverse index
    if (cargo["index"]==null) {
      cargo["index"] = new Map();
    }
    unstructuredDoc.split(" ").forEach((word) {
      Set wordSet = cargo["index"][word];
      if (wordSet==null) {
        wordSet = new Set();
      }

      wordSet.add(docId);
      cargo["index"][word] = wordSet;
    });
    
    return docId;
  }
  
  List<String> search(String sentence) {
    List<String> findDocs = new List();
    if (cargo["index"]!=null) {
      Set docIdsRetrieval;
      for (String term in sentence.split(" ")) {
        if (cargo["index"][term]!=null) {
          if (docIdsRetrieval==null) {
            docIdsRetrieval = cargo["index"][term];
          } else {
            docIdsRetrieval = docIdsRetrieval.intersection(cargo["index"][term]);
          }
        }
      }
      
      for (var docId in docIdsRetrieval) {
        findDocs.add(cargo["docIds"][docId]);
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