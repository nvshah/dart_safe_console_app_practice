import 'dart:math';

abstract class BST<T extends Comparable<T>>{
  bool add(T t);
  bool remove(T t);
  int get size;
  bool contains(T t);
  T get getMin;
  T get getMax;
  int get height;
}

class Node<T>{
  T data;
  Node? left, right;
  Node(this.data, {this.left, this.right});
}

// abstract class Traversal<T> {
//   // Instantiation of class is not allowed
//   Traversal._();
//
//   static List<T> inOrderTraversal(Node<T> root){
//
//   }
//
//
// }

class BinarySearchTree<E extends Comparable<E>> implements BST<E>{
  int _size = 0;  // nodes count
  Node? root;

  int get size => _size;
  bool get isEmpty => _size == 0;

  E get getMin  => root != null ? _findMin(root!).data : -1;
  E get getMax  => root != null ? _findMax(root!).data : -1;
  int get height => _findHeight(root);


  @override
  bool contains(E e) {
    return _contains(root, e);
  }

  bool _contains(Node? n, E e){
    if(n == null) return false;
    var cmp = e.compareTo(n.data);
    if(cmp < 0){
      // search in left part
      return _contains(n.left, e);
    }else if(cmp > 0){
      // search in right part
      return _contains(n.right, e);
    }
    return true;
  }

  @override
  bool add(E e) {
    if(contains(e)){
      return false;
    }
    root = _add1(root, e);
    _size++;
    return true;
  }

  /// Add element {e} in BST from given node {n} & return root node back
  Node _add1(Node? n, E e){
    // Base Case : Found the Leaf Node
    if(n == null){
      // reach the ground (child of leaf node) so add new elem {e} here
      // this added element will be root node as well as its a single node in sub-part at moment
      return Node(e);
    }else{
      var val = n.data;
      if(e.compareTo(val) < 0){
        // Add {e} in left part
        n.left = _add1(n.left, e);
      }else{
        // Add {e} in Right part
        n.right = _add1(n.right, e);
      }
      return n;
    }
  }

  /// Add element {e} in BST from given node {n}  (Not yet Completed)
  void _add2(Node n, E e){
    // In BST new elem is always added as Leaf node child
    var v = n.data;
    if(e.compareTo(v) < 0){
      if(n.left == null){
        // Found the Pos
        n.left = Node(e);
      }else{
        _add2(n.left!, e);
      }
    }else{
      if(n.right == null){
        // Found the Pos
        n.right = Node(e);
      }else{
        _add2(n.right!, e);
      }
    }
  }


  @override
  bool remove(E e){
    if(!contains(e)){
      return false;
    }
    root = _remove1(root, e);
    _size--;
    return true;
  }

  /// remove node with val {e} in BST & return root node at moment after removal
  Node? _remove1(Node? n, E e){
    if(n == null){ // no node found with val {e}
      return null;
    }
    var cmp = e.compareTo(n.data);
    //Dig into left sub tree
    if(cmp < 0){
      n.left = _remove1(n.left, e);
    }
    // Dig into right Sub tree
    else if(cmp > 0){
      n.right = _remove1(n.right, e);
    }
    // Found {e}
    else{
      if(n.left == null){  // after removal root node will be its immediate right child descent
        return n.right;
      }
      else if(n.right == null){
        return n.left;  // after removal root node will be its immediate left child descent
      }
      else{
        // Find the leftMost Node in Right SubTree
        var tmp = _findMin(n.right!);

        // Swap the Data (Emulate Swapping but not actually Swapping)
        // So that curr node n can be discarded
        n.data = tmp.data;

        // remove the leftmost node in Right SubTree (currently swapped with)
        // Preventing 2 nodes having same value
        n.right = _remove1(n.right!, tmp.data);
      }
    }
    return n;
  }

  /// Find min val starting search from {n}
  Node _findMin(Node n){
    while(n.left != null) {n = n.left!;}
    return n;
  }

  /// Find max val starting search from {n}
  Node _findMax(Node n){
    while(n.right != null) {n = n.right!;}
    return n;
  }

  /// Find Height of tree starting search from {n}
  int _findHeight(Node? n){
    if(n == null) return 0;
    return 1 + max(_findHeight(n.left), _findHeight(n.right));
  }

}

