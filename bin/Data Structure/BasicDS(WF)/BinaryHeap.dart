import 'dart:collection';
import 'dart:math';

/**
 * Properties
 * Last Parent idx = size/2 - 1
 */

abstract class IBinaryHeap<T> {
  bool get isEmpty;

  int get size;

  T peek();

  void clear();

  T poll();

  void add(T e);

  void remove(T e);

  void heapify(int k);
}

class BinaryHeap<T extends num> {
  //int _capacity = 16;
  //int _size = 0;

  var _items = <T>[];

  BinaryHeap();

  BinaryHeap.from(List<T> fromElems) {
    _items = List.from(fromElems);
    //_size = _items.length;

    //heapify Up, O(n) -> tighter bound, O(nlogn) -> worst case
    for (int i = max(0, size ~/ 2); i >= 0; i--) {
      heapifyDown(i);
    }
  }

  /* #region */
  //UTILITY Methods------

  int get size => _items.length;

  bool get isEmpty => _items.isEmpty;

  int getLeftChildIdx(int idx) => 2 * idx + 1;

  int getRightChildIdx(int idx) => 2 * idx + 2;

  int getParentIdx(int idx) => idx - 1 ~/ 2;

  bool hasLeftChild(int idx) => getLeftChildIdx(idx) < size;

  bool hasRightChild(int idx) => getRightChildIdx(idx) < size;

  bool hasParent(int idx) => getParentIdx(idx) >= 0;

  T getLeftChild(int idx) => _items[getLeftChildIdx(idx)];

  T getRightChild(int idx) => _items[getRightChildIdx(idx)];

  T getParent(int idx) => _items[getParentIdx(idx)];

  ///swap items between idx1 <-> idx2
  void swap(int idx1, int idx2) {
    var temp = _items[idx2];
    _items[idx2] = _items[idx1];
    _items[idx1] = temp;
  }

  /* #endregion */

  ///Get root element of heap Tree
  T? peek() {
    if (isEmpty) return null;
    return _items[0];
  }

  ///Remove and get root element of Heap tree
  T poll() {
    if (isEmpty) throw Exception("Empty Heap");
    T item = _items[0];
    _items[0] = _items[size - 1];
    //_size--;
    heapifyDown();
    return item;
  }

  ///add item e into the heap tree
  void add(T e) {
    _items.add(e);
    heapifyUp();
  }

  ///remove item e from heap tree
  T remove(T e) {
    int itemIdx = _items.indexOf(e);  // O(n) lookup
    if (itemIdx == -1)
      throw Exception("Element Not Present"); //swap with last element
    if (itemIdx == size - 1) {
      return _items.removeLast();
    } //only 1 element
    T item = _items[itemIdx];
    swap(itemIdx, size - 1);
    _items.removeLast();
    heapify(itemIdx);
    return item;
  }

  ///heapify the nodes from node present at index = k, (i.e heap impl using array)
  void heapify([int k = 0]) {
    var item = _items[k];
    heapifyDown(k);
    if (_items[k] == item) {
      //Not moved down so can be moved up
      heapifyUp(k);
    }
  }

  ///heapify the process in upwards direction i.e from child to parent in Binary Heap tree
  void heapifyUp([int k = -1]) {
    int idx = k > 0 ? k : size - 1;
    while (hasParent(idx) && getParent(idx) > _items[idx]) {
      swap(idx, getParentIdx(idx));
      idx = getParentIdx(idx);
    }
  }

  ///heapify the process in downwards direction i.e from parent to child in Binary Heap tree
  void heapifyDown([int k = 0]) {
    int idx = k;
    while (hasLeftChild(idx)) {
      //If there is left child then only right child can exist
      int smallerChildIdx = getLeftChildIdx(idx);
      if (hasRightChild(idx) && (getRightChild(idx) < getLeftChild(idx))) {
        smallerChildIdx = getRightChildIdx(idx);
      }
      if (_items[idx] <= _items[smallerChildIdx]) {
        break;
      }
      swap(idx, smallerChildIdx);
      idx = smallerChildIdx;
    }
  }

  List<T> nSmallest(int n){
    var ans = <T>[];
    var b = min(size, n);
    for(var i=0; i<b; i++){
      ans.add(poll());
    }
    return ans;
  }
}

/**
 * A min priority Queue impl using a binary heap
 * Hash Table :- track each element pos inside array for quick removals
 */
class BinaryHeapQuickRemoval<T extends num> {
  /// i.e Don't Waste time in finding index of an element whist removal

  // map for element to its various position in Heap (i.e sorted idx set)
  // This allows us to have O(log(n)) removal & O(1) element containment check at the cost of some extra space
  var _map = <T, SplayTreeSet<int>>{};

  // dynamic array for an heap (using List data structure)
  var _heap = <T>[];

  int get heapSize => _heap.length;

  int get getLastParentIdx => max(0, heapSize ~/ 2 - 1);

  /* #region */
  //UTILITY Methods------

  int get size => _heap.length;

  bool get isEmpty => _heap.isEmpty;

  int getLeftChildIdx(int idx) => (2 * idx) + 1;

  int getRightChildIdx(int idx) => (2 * idx) + 2;

  int getParentIdx(int idx) => (idx - 1) ~/ 2;

  bool hasLeftChild(int idx) => getLeftChildIdx(idx) < size;

  bool hasRightChild(int idx) => getRightChildIdx(idx) < size;

  bool hasParent(int idx) => getParentIdx(idx) >= 0;

  T getLeftChild(int idx) => _heap[getLeftChildIdx(idx)];

  T getRightChild(int idx) => _heap[getRightChildIdx(idx)];

  T getParent(int idx) => _heap[getParentIdx(idx)];

  BinaryHeapQuickRemoval();

  BinaryHeapQuickRemoval.from(List<T> elems, {bool isSorted = false}) {
    int heapSize = elems.length;
    //get the last node parent element i.e (k-1)//2
    for (var i = 0; i < heapSize; i++) {
      _addToMap(elems[i], i);
      _heap.add(elems[i]); // add directly to end of heap
    }

    if (!isSorted) {
      //heapify for each parent node from bottom->top
      for (var i = getLastParentIdx; i >= 0; i--) {
        heapifyDown(i);
      }
    }
  }

  T? peek() {
    if (isEmpty) return null;
    return _heap[0];
  }

  /// O(1) lookup
  bool contains(T e) {
    return _map.containsKey(e);
  }

  /// Clear the Heap & Map
  void clear() {
    _heap.clear();
    _map.clear();
  }

  /// Remove Root of Heap
  T pop() {
    return removeAt(0);
  }

  ///Add element to heap
  void add(T e) {
    _heap.add(e);
    _addToMap(e, size - 1); // index of last element is current size-1
    heapifyUp();
  }

  /// remove element using Map ie constant lookup
  /// return true if elem removed successfully
  bool remove(T e){
    // last idx of element in array
    int idx = mapGet(e);  // O(1) time for lookup
    if(idx == -1) return false;
    removeAt(idx);  // remove at given idx
    return true;

  }

  /// Remove element at give index
  T removeAt(int idx) {
    if (0 > idx || idx > size){
      throw 'Invalid index';
    }
    int idxOfLastItem = size-1;
    if(idx == idxOfLastItem){
      var t = _heap.removeLast();
      _removeFromMap(t, idx);
      return t;
    }else{
      swap(idx, idxOfLastItem);  // swap elem to be removed to last pso in array
      // Wipe Out the last element ie desired element
      var t = _heap.removeLast();
      _removeFromMap(t, idxOfLastItem);
      // Heapify  at idx
      heapify(idx);
      return t;
    }
  }


  ///heapify the nodes from node present at index = k, (i.e heap impl using array)
  void heapify([int k = 0]) {
    var item = _heap[k];
    heapifyDown(k);
    if (_heap[k] == item) {
      //Not moved down so can be moved up
      heapifyUp(k);
    }
  }

  ///heapify the process in upwards direction i.e from child to parent in Binary Heap tree
  void heapifyUp([int k = -1]) {
    int idx = k > 0 ? k : size - 1;
    while (hasParent(idx) && (getParent(idx) > _heap[idx])) {
      swap(idx, getParentIdx(idx));
      idx = getParentIdx(idx);
    }
  }

  ///heapify the process in downwards direction i.e from parent to child in Binary Heap tree
  void heapifyDown([int k = 0]) {
    int idx = k;
    while (hasLeftChild(idx)) {
      //If there is left child then only right child can exist
      int smallerChildIdx = getLeftChildIdx(idx);
      if (hasRightChild(idx) && (getRightChild(idx) < getLeftChild(idx))) {
        smallerChildIdx = getRightChildIdx(idx);
      }
      if (_heap[idx] <= _heap[smallerChildIdx]) {
        break;
      }
      swap(idx, smallerChildIdx);
      idx = smallerChildIdx;
    }
  }

  ///Add an element & its position inside mapping
  void _addToMap(T elem, int idx) {
    var setOfIdx = _map.putIfAbsent(elem, () => SplayTreeSet<int>());
    setOfIdx.add(idx);
  }

  ///remove an element entry from Map
  void _removeFromMap(T elem, int idx){
    var treeSet = _map[elem];
    if(treeSet == null) throw 'Something Went Wrong while Removal';
    treeSet.remove(idx); // O(log(n)) removal time by TreeSet
    // if all idx are removed then do clean the memory
    if (treeSet.isEmpty) _map.remove(elem);
  }

  ///swap items between idx1 <-> idx2
  void swap(int idx1, int idx2) {
    T v1 = _heap[idx1];
    T v2 = _heap[idx2];
    var temp = v2;
    _heap[idx2] = v1;
    _heap[idx1] = temp;
    mapSwap(v1, v2, idx1, idx2);
  }

  ///Swap the values in mappings
  ///between keys i.e v1 into k2 & v2 into k1
  void mapSwap(T k1, T k2, int v1, int v2) {
    _map[k1]!.remove(v1);
    _map[k2]!.remove(v2);
    _map[k1]!.add(v2);
    _map[k2]!.add(v1);
  }

  /// get last idx of element in heap
  int mapGet(T e){
    return _map[e]?.last ?? -1;
  }

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   var sb = StringBuffer();
  //   va n = 
  //   for
  //   return _heap.toString();
  // }
}

main() {
  var arr = [1, 5, 4, 8, 11, 9, 6];
  var heaper = BinaryHeapQuickRemoval<int>.from(arr);
  heaper.add(3);
  heaper.add(-2);
  print(heaper);

}
