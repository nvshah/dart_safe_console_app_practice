//library linked_list

/**
 * Doubly Linked List
 */

///Node- represents the data
class Node<T> {
  T? data;
  Node<T>? prev, next;

  Node({this.data, this.prev, this.next});
  @override
  String toString() => data.toString();
}

class DoublyLinkedList<T> extends Iterable<T> {
  int _size = 0;
  Node<T>? _head, _tail;

  int get size => _size;
  @override
  bool get isEmpty => _size == 0;

  ///del all nodes of linked list
  void clear() {
    if (_size == 0) {
      return;
    }
    var trav = _head;
    while (trav != null) {
      var next = trav.next;
      trav.prev = trav.next = null;
      trav.data = null;
      trav = next;
    }
    _head = _tail = null;
    _size = 0;
  }
  
  ///add at end
  void append(T e){
    addAtEnd(e);
  }

  ///add element at start, O(1)
  void addAtStart(T e) {
    if (isEmpty) {
      _head = _tail = Node<T>(data: e, prev: null, next: null);
    } else {
      _head!.prev = Node<T>(data: e, prev: null, next: _head);
      _head = _head!.prev;
    }
    _size++;
  }

  ///add element at last, O(1)
  void addAtEnd(T e) {
    if (isEmpty) {
      _head = _tail = Node<T>(data: e, prev: null, next: null);
    } else {
      _tail!.next = Node<T>(data: e, prev: _tail, next: null);
      _tail = _tail!.next;
    }
    _size++;
  }

  ///add element at index idx, O(n)
  void addAt(int idx, T e) {
    if (idx < 0 || idx > size) {
      throw Exception("Illegal Index");
    }
    if (idx == 0) {
      addAtStart(e);
      return;
    }
    if (idx == size) {
      addAtEnd(e);
      return;
    }

    var trav = _head;
    //for (ith index) we will have (i-1-1) transitions
    for (var i = 0; i < idx - 1; i++) {
      trav = _head!.next;
    }
    final node = Node<T>(data: e, prev: trav, next: trav!.next);
    //delete i+1'th prev node first (ref counting), Garbage Collection
    node.next!.prev = node;
    trav.next = node;

    _size++;
  }

  T peekFirst() {
    if (isEmpty) throw Exception('Empty List');
    return _head!.data!;
  }

  T peekLast() {
    if (isEmpty) throw Exception('Empty List');
    return _tail!.data!;
  }

  T popFirst() {
    if (isEmpty) throw Exception('Empty List');

    var data = _head!.data;
    _head = _head!.next;
    --_size;

    //If list is empty then set tail to null
    if (isEmpty) {
      _tail = null;
    } else {
      //Memory Cleanup
      _head!.prev = null;
    }

    return data!;
  }

  T popLast() {
    if (isEmpty) throw Exception('Empty List');

    var data = _tail!.data;
    _tail = _tail!.prev;
    --_size;

    //If list is empty then set tail to null
    if (isEmpty) {
      _head = null;
    } else {
      //Memory Cleanup
      _tail!.next = null;
    }
    return data!;
  }

  ///remove the node from Linked List, It is assert that node is actual object present in Linked List
  T _remove(Node<T> n) {
    //Head
    if (n.prev == null) return popFirst();
    //Tail
    if (n.next == null) return popLast();

    //Remove Connection (double sided)
    n.prev!.next = n.next;
    n.next!.prev = n.prev;

    //Memory Cleanup (GC) (reference Counting ob Object)
    var t = n.data;
    n.prev = n.next = n.data = null;
    --_size;

    return t!;
  }

  T removeAt(int idx) {
    if (idx < 0 || idx >= size) {
      throw Exception('Illegal index');
    }

    Node<T> trav;

    if (idx < _size ~/ 2) {
      //First Half - Search from Front
      trav = _head!;
      for (var i = 0;  i != idx; i++) {
        trav = trav.next!;
      }
    } else {
      //Second Half - Search From back
      trav = _tail!;
      for (var i = _size - 1, trav = _tail; i != idx; i--) {
        trav = trav!.prev;
      }
    }

    return _remove(trav);
  }

  ///remove the first node that matches value o in Linked List
  ///NOTE :- If you want to compare object value-wise then must override == operator passed in as argument
  bool remove(Object o){
    if(isEmpty) throw Exception('LinkedList is Empty');
    var trav = _head;
    while(trav != null){
      if(trav.data == o){
        _remove(trav);
        return true;
      }
      trav = trav.next;
    }
    return false;
  }

  //return index of Object in Linked List
  int find(Object o){
    if(isEmpty) return -1;
    var trav = _head;
    for(var i=0; trav != null; i++){
      if(trav.data == o){
        return i;
      }
      trav = trav.next;
    }
    return -1;
  }

  @override
  Iterator<T> get iterator => _DLLIterator(_head);

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write("[ ");
    if(_head != null){
      sb.write(" null <-> ");
    }
    sb.writeAll(this, " <-> ");
    if(_tail != null){
      sb.write(" <-> null ");
    }
    sb.write(" ]");
    return sb.toString();
  }
}

class _DLLIterator<T> extends Iterator<T>{
  Node<T>? currentNode;
  late T data;
  _DLLIterator(this.currentNode);

  @override
  T get current => data;

  @override
  bool moveNext() {
    if(currentNode != null){
      data = currentNode!.data!;
      currentNode = currentNode!.next;
      return true;
    }
    return false;
  }

}

void main() {
  final dll = DoublyLinkedList<int>();
  dll.append(20);
  dll.append(30);
  dll.addAtStart(10);
  dll.append(40);

  dll.remove(30);

  print(dll.find(40));

  print(dll);
}
