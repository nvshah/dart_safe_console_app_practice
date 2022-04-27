import 'dart:core';
import 'dart:math';

/**
 * IPQ :- used when Priority Dynamic Changes once given in Queue
 *
 *
 * REMEMBER
 * Element :- (Key, Val)
 * Key Indexes :- Index representing Key of an element
 * priority_queue_array :- domain :- [0, size)  // [0,1,,2,3,...]
 * &
 * We need bi-directional mapping between Key_Indexes & PQ_Domain Array
 *
 * In a nutshell :
 *   Key --> represented by -> key index (ie ki)
 *   &
 *   ki is used by Heap (ie Array DS) to store as member
 *
 *   With the help of ki we can get corresp val ie vi
 */


abstract class MinIndexedHeap<T>{
  int get size;
  // The position map (pm) maps key indexes (ki) to where the position of that key
  // is represented in the Priority Queue in the domain [0, size)
  // Val :- Pos in PQ
  // idx :- Key Indexes (ki) // ie indexed by the Key-Indexes (ki)
  List<int> get pm;

  // The Inverse map (im)
  // stores the indexes of the keys in the range [0, size) which make up the priority Queue
  // Note : inverseMap & positionMap are inverse of each other
  //        => ie pm[im[i]] = im[pm[i]]
  // val :- Key-Idx
  // idx :- Pos in PQ  // ie indexed by the PQ's positions
  List<int> get im;

  // The value associated with the Key.
  // NOTE :- Array is indexed by the key-indexes (ki)
  List<T> get vals;

}

/// NOTE {int} :- can be then extended to Generic type (ie but Comparable)
class MinIndexedBinaryHeap{
  int size = 0;  // curr size of Heap
  int maxSize = 0;  // Limit of Heap

  // Lookup array to track child/parent indexes of each node
  var child = <int>[];
  var parent = <int>[];

  //! -> Note each key is assigned unique idx

  // PQ (Heap) is indexed by positions in range [0, size)

  // The position map (pm) indicates idx of node in heap for a given key idx (ki)
  // Val :- Pos in PQ
  // idx :- Key Indexes    // ie indexed by the Key Indexes (ki)
  var pm = <int>[];

  // The Inverse map (im) := heap idx alike array
  // At this particular pos (ie idx of array) in Heap, which key-idx is present
  // Note : inverseMap & positionMap are inverse of each other
  //        => ie pm[im[i]] = im[pm[i]]
  // val :- Key-Idx
  // idx :- Pos in PQ    // ie indexed by the Heap Index
  var im = <int>[];

  // The value associated with the Key.
  // NOTE :- Array is indexed by the key-indexes (ki)
  var vals = <int>[];

  MinIndexedBinaryHeap(int maxSz){
    assert(maxSz > 0);

    var degree = 2;
    maxSize = max(degree+1, maxSz);

    // im[i] := denotes the ki (ie key index) corresponding to pos i in heap(array)
    im = List.filled(maxSize, -1);
    // pm[i] := denotes the pos of key of {ki} in heap(Array)
    pm = List.filled(maxSize, -1);
    child = List.generate(maxSize, (i) => i-1 ~/ 2);
    parent = List.generate(maxSize, (i) => i*2 + 1);
    vals = List.filled(maxSize, 0);

    // // initialize the parent & child
    // for(var i=0; i<maxSize; i++){
    //   parent[i] = i-1 ~/ 2;
    //   child[i] = i*2 + 1;
    // }
  }

  // ---- GETTERS ----

  int get Size => size;  // get the size of current Heap
  bool get IsEmpty => size == 0;

  void assertKeyInBounds(int ki){
    assert(ki < 0 || ki >= maxSize, "Key Index Out of Bounds");
  }

  void isNotEmptyOrThrow(){
    if(IsEmpty) throw Exception("Priority Queue Underflow");
  }

  // --- METHODS -----

  /// check if key index {ki} is present in Heap
  bool contains(int ki){
    assertKeyInBounds(ki);
    return pm[ki] != -1;
  }

  /// Return the key-index of elem that is top on Heap (ie Root)
  int peekMinKeyIdx(){
    isNotEmptyOrThrow();
    return im[0];
  }

  /// Pop the Elem corresp to key present at top of heap
  int pollMinKeyIdx(){
    var minKeyIdx = peekMinKeyIdx();
    delete(minKeyIdx);  
    return minKeyIdx;
  }

  /// Return the Val corresp to Key of key-index that is top on Heap (ie Root)
  int peekMinVal(){
    isNotEmptyOrThrow();
    var keyIdx = im[0];
    return vals[keyIdx];
  }

  /// Pop the Elem corresp to key present at top of heap & return val corresp to popped key
  int pollMinVal(){
    var minVal = peekMinVal();
    delete(peekMinVal());
    return minVal;
  }

  void insert(int ki, int val){
    if(contains(ki)) throw Exception('Index already exists');
    pm[ki] = size;
    im[size] = ki;
    vals[size] = val;
    swim(size++);   // bubble up
  }

  // TODO Continue From Here ...

}