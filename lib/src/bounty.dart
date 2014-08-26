part of bountyhunter;

class Bounty implements Comparable {
  
  double score;
  int docId;
  String name;
  
  Bounty(this.score, this.docId, this.name);
  
  int compareTo(Bounty other) {
    if (other.score < this.score) {
      return -1;
    }
    return 1;
  }
  
}