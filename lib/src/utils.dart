part of bountyhunter;

Set convertListToSet(List list) {
  Set set = new Set();
  for (var value in list) {
    set.add(value);
  }
  return set;
}