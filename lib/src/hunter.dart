part of bountyhunter;

class Hunter {
  
  static String LATEST_DOCID = "latest_docId";
  
  CargoBase cargo;
  Configuration configuration = new Configuration();
  
  int _N = 0; 
  
  Hunter(this.cargo);
  
  int feedDoc(String key, String unstructuredDoc) {
    // lookup if doc already exist!
    if (cargo["docs"]==null) {
      cargo.setItem("docs", new Map());
      cargo.setItem("docIds", new Map());
    }
    // reverse index
    Map index = cargo.getItemSync("index", defaultValue: new Map()); 
    // store tf
    Map tf = cargo.getItemSync("tf", defaultValue: new Map()); 
    
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
      index.forEach((key, value) {
        if (value is Set) {
          Set postings = value;
          postings.remove(docId);
        }
      });
      tf.forEach((key, value) {
        if (value is Map) {
          Map mapWithDocId = value;
          
          mapWithDocId.remove(docId);
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
        
        _setTfInStore(docId, word);
      }
    });
    
    _calcN();
    
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
      
      // calculate scores for every document
      int N = cargo["docIds"].length;
      for (var docId in docIdsRetrieval) {
        Vector scorings = new Vector();
        for (String term in sentence.split(" ")) {
          int tf = cargo["tf"][term]!=null ? cargo["tf"][term][docId] : 0;
          Set postings = cargo["index"][term];
          int df = postings!=null ? postings.length : 0;
          
          double score = (1 + Math.log(tf)) * Math.log(N/df);
          scorings.add(score);
        }
        Vector normScoring = scorings.normalize();
        double totalScore = normScoring.avg();
        
        findDocs.add(new Bounty(totalScore, docId, cargo["docIds"][docId]));
      }
    }
    return findDocs;
  }
  
  // set a term frequency in a certain document
  void _setTfInStore(int docId, String word) {
    Map tf_map = cargo["tf"][word];
    if (tf_map==null) {
       tf_map = new Map();
    }
    if (tf_map[docId]==null) {
       tf_map[docId] = 0;
    } 
    tf_map[docId]++;
    cargo["tf"][word] = tf_map;
  }
  
  void _calcN() {
    Map tf = cargo.getItemSync("tf", defaultValue: new Map()); 
    _N = 0;
    tf.forEach((key, value) {
      if (value is Map) {
         Map counters = value;
                
         counters.forEach((key, int count) {
           _N +=count;
         }); 
       }
    });
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