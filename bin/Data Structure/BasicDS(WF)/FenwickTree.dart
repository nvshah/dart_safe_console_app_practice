
/// Binary Index Tree
class FenwickTree{
  late List<double> _tree;
  late List<double> _values;

  /// Create a Empty Fenwick Tree
  FenwickTree(int size){
    //1 based indexing so +1
    _tree = List.generate(size+1, (index) => 0.0);
  }

  FenwickTree.from(List<double> vals){
    // Clone original values (since we mutate the inplace based on lsb whilst init)
    _tree = [0, ...vals];  // 1 based indexing
    _values = vals;
    for(int i=1; i <= _tree.length; i++){
      var j = i + _lsb(i);  // {j} is the index that will be affected by the current index {i}
      if(j < _tree.length){
        _tree[j] += _tree[i];  // Update dependent as well
      }
    }
  }

  /// calculate the lsb() ie Least Significant Bit Corresp 2's value
  /// lsb(108) = lsb(0b1101100) = 0b100 = 4
  /// lsb(64) = lsb(0b1000000) = 0b1000000 = 64
  /// lsb(96) = lsb(0b1100000) = 0b100000 = 32
  int _lsb(int n){
    // return the lowest one bit value
    return n & -n;
  }

  /// calculate the sum upto idnex {u} (included) (ie One based)
  double prefixSum(int u){
    double sum = 0;
    int i = u+1;
    while(i > 0){
      sum += _tree[i];
      // Backward Lookup
      i &= ~_lsb(i);   // Equi => i -= _lsb(i)
      // i-= _lsb(i);
    }
    return sum;
  }

  /// calculates the sum from index [l, u]
  double sum(int l, int u){
    if(l > u) throw Exception("Make Sure l <= u");
    return prefixSum(u) - prefixSum(l-1);
  }

  /// Update the value at index {i} of original array by adding the val k to it
  /// & likewise update to all dependents
  void addAt(int i, double v){
    int j = i+1; // as indexing starts from 1
    while(j < _tree.length){
      print(j);
      _tree[j] += v;
      j += _lsb(j);   // Forward Update
    }
    _values[i] += v;
  }

  /// get original value
  double get(int i)  => _values[i];  // sum(i, i)

  /// Make value at index{i} equal to {v}
  void set(int i, double v){
    var originalVal = _values[i];
    // var originalVal = sum(i, i)
    var valToAdd = v - originalVal;
    addAt(i+1, valToAdd);   // 1 based indexing for tree
    _values[i] = v;
  }

  List<double> getAllPrefixSum(){
    return [for(int i=1; i<_tree.length; i++) prefixSum(i-1)];
  }

  List<double> get getOriginalVals => _values;


  @override
  String toString() {
    return 'FenWick Tree -> $_tree';
  }
}

void main() {
  var vals = <double>[1, 2, 10, 9, 6, 20, 18];
  var fwTree = FenwickTree.from(vals);
  var prefixSum = fwTree.getAllPrefixSum();
  print(prefixSum);


  print(fwTree);
  fwTree.addAt(2, 20);
  print(fwTree);
  print(fwTree._values);
  print(fwTree.sum(0, 3));

  //print(fwTree.lsb(3));
}