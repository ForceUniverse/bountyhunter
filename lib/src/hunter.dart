part of bountyhunter;

class Hunter {
  
  static String LATEST_DOCID = "latest_docId";
  
  CargoBase cargo;
  
  Configuration configuration = new Configuration();
  Normalizer normalizer = new Normalizer();
  
  int _N = 0; 
  
  Hunter(this.cargo);
  
  int feedDoc(String key, String unstructuredDoc) {
    // lookup if doc already exist!
    Map docs_map = cargo.getItemSync("docs", defaultValue: new Map()); 
    Map docIds_map = cargo.getItemSync("docIds", defaultValue: new Map()); 
    // reverse index
    Map index = cargo.getItemSync("index", defaultValue: new Map()); 
    // store tf
    Map tf = cargo.getItemSync("tf", defaultValue: new Map()); 
    
    var docInfo = cargo["docs"][key];
    
    int docId;
    if (docInfo==null) {
      // put docId info into persistence
      docId = _latestDocId();

      docs_map[key] = docId;
      cargo["docs"] = docs_map;
      
      docIds_map["${docId}"] = key;
      cargo["docIds"] = docIds_map;
    } else {
      docId = docInfo;
      
      // docId already exist so clear the document in the index before re-indexing the new document
      List removals = new List();
      index.forEach((key, value) {
        if (value is List) {
          List postings = value;
          postings.remove(docId);
        }
      });
      removals.forEach((o) => index.remove(o));
      removals.clear();
      tf.forEach((key, value) {
        if (value is Map) {
          Map mapWithDocId = value;
          
          mapWithDocId.remove("${docId}");
          
          if (mapWithDocId.length==0) {
            removals.add(key);
          }
        }
      });
      removals.forEach((o) => tf.remove(o));
    }
    
    List words = unstructuredDoc.split(" ");
    for (String word in words) {
      word = normalizer.normalize(word);
      if (!configuration.skipWord(word)) {
        List wordSet = index[word];
        if (wordSet==null) {
          wordSet = new List();
        }
        if (!wordSet.contains(docId)) {
            wordSet.add(docId);
            index[word] = wordSet;
        }
        
        tf = _setTfInStore(tf, "${docId}", word);
      }
    }
    cargo["tf"] = tf;
    cargo["index"] = index;
    
    return docId;
  }
  
  List<Bounty> search(String sentence) {
    List<Bounty> findDocs = new List();
    if (cargo["index"]!=null) {
      Set docIdsRetrieval;
      for (String term in sentence.split(" ")) {
        term = normalizer.normalize(term);
        if (cargo["index"][term]!=null && !configuration.skipWord(term)) {
          if (docIdsRetrieval==null) {
            docIdsRetrieval = convertListToSet(cargo["index"][term]);
          } else {
            docIdsRetrieval = docIdsRetrieval.intersection(convertListToSet(cargo["index"][term]));
          }
        }
      }
      
      // calculate scores for every document
      int N = cargo["docIds"].length;
      if (docIdsRetrieval!=null) {
        for (var docId in docIdsRetrieval) {
          Vector scorings = new Vector();
          List terms = sentence.split(" ");
          for (String term in sentence.split(" ")) {
            term = normalizer.normalize(term);
            int tf = cargo["tf"][term]!=null ? cargo["tf"][term]["${docId}"] : 0;
            Set postings = convertListToSet(cargo["index"][term]);
            int df = postings!=null ? postings.length : 0;
            
            double score = (1 + Math.log(tf)) * Math.log(N/df);
            scorings.add(score);
          }
          // only normalize it when you have more then one terms
          if (terms.length>1) {
            scorings = scorings.normalize();
          }
          double totalScore = scorings.avg();
          
          findDocs.add(new Bounty(totalScore, docId, cargo["docIds"]["${docId}"]));
        }
      }
    }
    // sort the bounties on score
    findDocs.sort((Bounty a, Bounty b) => a.compareTo(b));
    return findDocs;
  }
  
  // set a term frequency in a certain document
  Map _setTfInStore(Map tf, String docId, String word) {
    Map tf_map = tf[word];
    if (tf_map==null) {
       tf_map = new Map();
    }
    if (tf_map[docId]==null) {
       tf_map[docId] = 0;
    } 
    tf_map[docId]++;
    tf[word] = tf_map;
    
    return tf;
  }
  
  int _latestDocId() {
    int latestDocId = cargo[LATEST_DOCID];
    if (latestDocId==null) {
      cargo[LATEST_DOCID] = 1;
      latestDocId = 0;
    } else {
      cargo[LATEST_DOCID]++;
    }
    return latestDocId;
  }
  
}