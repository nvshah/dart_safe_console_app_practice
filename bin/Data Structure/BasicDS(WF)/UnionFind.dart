
/*
  BIJECTION
  This class works on index of array so you can manage any type of Object element
  Outside it just via manipulating idx of element regardless the type of elements
 */

class UnionFind {
  // #elements in the Union-Find
  final int _size;

  // size of grp if i is the root node else 0
  /// grp{i} -> #nodes belonging to that grp
  late List<int> grp_sizes;

  // for given i it will represent the parent or ancestor of i to which this i belong
  // so if ancestor[i] = i then i is root node
  late List<int>  ancestor_ids;  // (Bijection)

  // Total #grps/components in Union-Find approach
  int _totalGrps = 0;

  UnionFind(this._size){
    if(_size <= 0){
      throw Exception("size need to be > 0");
    }
    grp_sizes = List.filled(_size, 1);  // originally individual element will have its own grp
    ancestor_ids = List.generate(_size, (i) => i); // (self-root : Link to itself) initially each element will be root node
    _totalGrps = _size; // initially all have thier own individual grps
  }

  bool connected(int idx1, int idx2) => find(idx1) == find(idx2);

  int componentSize(int idx) => grp_sizes[idx];

  int get size => _size;
  int get components => _totalGrps;

  /// Given idx it will find the grp - root, where idx belongs to
  int find(int idx){
    // find the root of the component/grp/set
    int parent = idx;  // assume idx itself is root at first
    while(ancestor_ids[parent] != parent){
      parent = ancestor_ids[parent];
    }
    // Now parent is the root node
    int root = parent;
    // Compress the path leading to root
    // this operation is called "Path Compression"
    // It benefits with amortized Time Complexity
    int ptr = idx;
    while(ptr != root){
      int parent = ancestor_ids[ptr]; //grab parent
      ancestor_ids[ptr] = root; // make ancestor as root
      ptr = parent;  // update ptr
    }
    return root;
  }

  /// Combine 2 grp {nodes} into 1 if necessary
  void unify(int idx1, int idx2){
    int root1 = find(idx1);
    int root2 = find(idx2);

    if(root1 == root2){
      return;
    }
    if(componentSize(root1) >= componentSize(root2)){
      // assimilate root2 into root1
      ancestor_ids[root2] = root1;   // make root2 as part of root1 grp
      grp_sizes[root1] += grp_sizes[root2];  // update grp size
      grp_sizes[root2] = 0;
    }else{
      // assimilate root1 into root2
      ancestor_ids[root1] = root2;   // make root1 as part of root2 grp
      grp_sizes[root2] += grp_sizes[root1]; // update grp size
      grp_sizes[root1] = 0;
    }
    _totalGrps -= 1;  // as 2 grps gets unified into 1 so reduction of 1 grp cnt
  }
}

main() {

}
