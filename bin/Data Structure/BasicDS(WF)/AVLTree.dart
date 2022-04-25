import 'dart:math';

abstract class BalancedTree {
  int get height;

  int get size;

  bool contains(int v);

  bool insert(int v);

  bool remove(int v);
}

class Node {
  int bf; // balance factor
  int val; // value of this node
  int height; // height of this node in Tree
  Node? left, right;

  Node(this.val, {this.bf = 0, this.height = 0, this.left, this.right});
}

class AVL implements BalancedTree {
  late Node? _root;
  int _nodeCnt = 0;

  AVL({int? rootVal}) {
    if(rootVal != null) insert(rootVal);
  }

  @override
  int get height => _root?.height ?? -1;

  @override
  int get size => _nodeCnt;

  @override
  bool contains(int v) {
    return _contains(_root, v);
  }

  @override
  bool insert(int v) {
    if (contains(v)) return false;
    _root = _insert(_root, v);
    _nodeCnt++;
    return true;
  }

  @override
  bool remove(int v) {
    if(!contains(v)) return false;
    _root = _remove(_root, v);
    _nodeCnt--;
    return false;
  }

  bool validateBstInvariant(Node? n){
    if(n == null) return true;
    var isValid = true;
    if(n.left != null) isValid = isValid && n.left!.val < n.val;
    if(n.right != null) isValid = isValid && n.right!.val < n.val;
    return isValid && validateBstInvariant(n.left) && validateBstInvariant(n.right);
  }

  /// recursive method to check if val {v} exists in AVL tree
  bool _contains(Node? n, int v) {
    if (n == null) return false;
    if (v < n.val) return _contains(n.left, v);
    if (v > n.val) return _contains(n.right, v);
    return true; // Found
  }

  // Helper to update the BF & height of Node {n}
  void _updateAndBalance(Node n){
    // update balance factor & height val
    _update(n);
    // Re-balance Tree if necessary
    _balance(n);
  }

  /// recursive method to insert node for {v} in AVL tree
  Node _insert(Node? n, int v) {
    // returns curr node after inserting node with val {v} under curr node {n}
    if (n == null) return Node(v); // create new node at leaf level

    if (v < n.val) {
      n.left = _insert(n.left, v);
    } else {
      n.right = _insert(n.right, v);
    }
    _updateAndBalance(n);
    return n;
  }

  /// Update the balance factor & height for Tree Node {n}
  void _update(Node n) {
    final leftH = n.left?.height ?? -1;
    final rightH = n.right?.height ?? -1;

    n.height = 1 + max(leftH, rightH);
    n.bf = rightH - leftH;
  }

  /// recursive method to remove node of {v} in AVL tree
  Node? _remove(Node? n, int v) {
    // no node found & reach leaf level
    if (n == null) return null;
    // node {n} may present in left part
    if (v < n.val) {
      n.left = _remove(n.left, v);
      // node {n} may present in right part
    } else if (v > n.val) {
      n.right = _remove(n.right, v);
      // found the node to be removed
    } else {
      // 1. Case :- only right subtree or no subtree at all !
      if (n.left == null) {
        return n.right;
      }
      // 2. Case :- only left subtree or no subtree at all !
      if (n.right == null) {
        return n.left;
      }
      // Idea (Heuristic) :- Replace node from that part/subtree which has more nodes (so as to reduce balancing cost)
      // 3. Case :- Replace with largest value from left sub-tree
      if (n.left!.height > n.right!.height) {
        // find the largest val from left sub tree = successor
        var successor = _findMax(n.left!);
        // Emulating Swap between the largest val from left part to curr node
        n.val = successor.val;
        // remove largest val from left subtree (ie avoiding duplicates)
        n.left = _remove(n.left, v);
        // 3. Case :- Replace with largest value from left sub-tree
      } else {
        // find the smallest val from right sub tree = successor
        var successor = _findMin(n.right!);
        // Emulating Swap between the smallest val from right part to curr node
        n.val = successor.val;
        // remove smallest val from right subtree (ie avoiding duplicates)
        n.right = _remove(n.right, v);
      }
    }
    //! As some node is removed down the tree so height or bf might have change
    _updateAndBalance(n);
    return n;
  }

  /// Re-Balance a node if its balance factor is +2 or -2s
  Node _balance(Node n) {
    // Left Heavy SubTree
    if (n.bf == -2) {
      // -2 means left child has height = 2 => 2 edges atleast downside
      return (n.left!.bf == -1) ? _leftLeftCase(n) : _leftRightCase(n);
    }
    // Right Heavy SubTree
    if (n.bf == 2) {
      // +2 means right child has height = 2 => 2 edges atleast downside
      return (n.right!.bf == 1) ? _rightRightCase(n) : _rightLeftCase(n);
    }
    // Node {n} is balance already ie bf in { 0, +1 or -1 }
    return n;
  }

  /// Rotate {n} to the right side
  Node _rightRotation(Node n) {
    var p = n.left!; // new parent
    n.left = p.right;
    p.right = n;
    // Need to update the balance factor & height as 2 Nodes {n, p} changes their position in Tree
    _update(n); // Update child node first
    _update(p); // then later update parent node
    return p;
  }

  /// Rotate {n} to the right side
  Node _leftRotation(Node n) {
    var p = n.right!; // new parent
    n.right = p.left;
    p.left = n;
    // Need to update the balance factor & height as 2 Nodes {n, p} changes their position in Tree
    _update(n); // Update child node first
    _update(p); // then later update parent node
    return p;
  }

  // ------- ROTATION CASES --------

  /// Case 1. Heavy Left Side (straight)
  Node _leftLeftCase(Node n) {
    return _rightRotation(n); // just do 1 right rotation at current node {n}
  }

  /// Case 2. Heavy Left Side (ZigZag)
  Node _leftRightCase(Node n) {
    // 1. Left Rotation on left Node of {n}
    n.left = _leftRotation(n.left!);
    return _rightRotation(n);
  }

  /// Case 3. Heavy Right Side (straight)
  Node _rightRightCase(Node n) {
    return _leftRotation(n); // just do 1 left rotation at current node {n}
  }

  /// Case 4. Heavy Right Side (ZigZag)
  Node _rightLeftCase(Node n) {
    // 1. Right Rotation on Right Node of {n}
    n.right = _rightRotation(n.right!);
    return _leftRotation(n);
  }

  // ------- UTILS ----------

  /// Find min val starting search from {n}
  Node _findMin(Node n) {
    while (n.left != null) {
      n = n.left!;
    }
    return n;
  }

  /// Find max val starting search from {n}
  Node _findMax(Node n) {
    while (n.right != null) {
      n = n.right!;
    }
    return n;
  }
}

void main() {
  var avl = AVL(rootVal: 5);
  //List.generate(10, (i) => i+1).forEach((e) { avl.insert(e! * Random()!); });
}