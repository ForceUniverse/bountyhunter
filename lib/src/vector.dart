part of bountyhunter;

class Vector {
  
  List<double> values = new List<double>();
  
  void add(double value) {
    values.add(value);
  }
  
  double length() {
    double returnLen = 0.0;
    for (double value in values) {
      returnLen += (value*value);
    }
    return Math.sqrt(returnLen);
  }
  
  Vector normalize() {
    Vector norm = new Vector();
    double length = this.length();
    for (double value in values) {
       norm.add((value != 0.0) ? value/length : value);
    }
    return norm;
  }
  
  double sum() {
    double returnSum = 0.0;
    for (double value in values) {
      returnSum += value;
    }
    return returnSum;
  }
  
  double avg() {
    double sumValue = sum();
    return sumValue==0.0 ? sumValue / values.length : sumValue;
  }
}