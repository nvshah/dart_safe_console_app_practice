import 'dart:math';

import 'DoublyLibkedList.dart';

abstract class Queue<T> {
  void add(T elem);
  T poll();
  T peek();
  int get size;
  bool get isEmpty;
}

/**
 * Queue using LinkedList
 */
class LinkedQueue<T> extends Iterable<T> implements Queue<T> {
  late DoublyLinkedList<T>  _lst;

  LinkedQueue({T? firstElem}) {
    _lst = DoublyLinkedList();
    if(firstElem != null){
      add(firstElem);
    }
  }

  @override
  int get size => _lst.length;

  @override
  bool get isEmpty => _lst.isEmpty;

  ///Add element to end of queue
  @override
  void add(T elem) {
    _lst.append(elem);
  }

  /// remove & return element from front of queue
  @override
  T poll() {
    if (isEmpty) throw Exception("Queue is Empty");
    return _lst.popFirst();
  }

  ///return element at front of queue
  @override
  T peek() {
    if (isEmpty) throw Exception("Queue is Empty");
    return _lst.peekFirst();
  }

  @override
  Iterator<T> get iterator => _lst.iterator;

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write("Front -> ");
    sb.writeAll(this, ", ");
    sb.write(" <- End");
    return sb.toString();
  }
}

class IntQueue extends Iterable implements Queue<int>{
  int _size=0, _front=0, _end=0;
  late List<int> _arr;

  IntQueue({int maxSize=16}){
    _arr = List.filled(maxSize, 0);
  }

  @override
  int get size => _size;
  bool get isEpmty => _size ==0;
  bool get isFull => _size == _arr.length;

  @override
  int poll() {
    if(isEmpty) throw Exception("Queue is Empty");
    _front %= _arr.length;
    _size--;
    return _arr[_front];
  }

  @override
  int peek() {
    if(isEmpty) throw Exception("Queue is Empty");
    _front %= _arr.length;
    return _arr[_front];
  }

  @override
  void add(int elem) {
    if(isFull) throw Exception("Queue is Full");
    _arr[_end++] = elem;
    _end %= _arr.length;
    _size++;
  }

  @override
  Iterator<int> get iterator => _arr.iterator;
}

void main() {
    // var q = LinkedQueue<int>(firstElem:10);
    // q.provide(20);
    // q.provide(30);
    // q.grab();   //10
    // q.provide(40);
    // print(q);

    final timer = Stopwatch();
    int n = pow(10, 7) as int;
    IntQueue intQ = IntQueue(maxSize: n);
    timer.start();
    for (int i = 0; i < n; i++) intQ.add(i);
    for (int i = 0; i < n; i++) intQ.poll();
    timer.stop();
    print('TIme: ${timer.elapsed.inMilliseconds / 1e3}');
}
