List<int> getList(){
  print('List -> Eager');
  var l = <int>[];
  for(var i = 0; i<6; i++){
    l.add(i);
    print('l <- $i');
  }
  print('List -> Over');
  return l;
}

Iterable<int> getGenerator() sync*{
  print('Generator -> Lazy');
  for(var i = 0; i<6; i++){
    print('g -> $i');
    yield i;
  }
  print('Generator -> Over');
}

void main() {
  var l = getList();
  var g = getGenerator();
  print(l.last);
  print(g.first);

  var incrementer = Iterable<int>.generate(5);  //range in python
  print(incrementer.last);
}