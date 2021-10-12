
///Abstract Data Type (ADT)
abstract class Stack<T> {
  void push(T e);
  T pop();
  T peek();
  int search(T e);
}

///Implement Stack DS using List/DynamicArray in dart
class StackViaList<T> extends Iterable<T> implements Stack<T> {
  late List<T> _lst;

  StackViaList({T? firstItem}) {
    _lst = <T>[if (firstItem != null) firstItem];
  }

  int get size => _lst.length;

  @override
  bool get isEmpty => _lst.isEmpty;

  ///push an element at top of the stack
  @override
  void push(T e) => _lst.add(e);

  ///Remove & Return the Top-Most Item on Stack
  @override
  T pop() {
    if (isEmpty) throw Exception("Stack is Empty");
    return _lst.removeLast();
  }

  ///Return the Top-most item on Stack
  @override
  T peek() {
    if (isEmpty) throw Exception("Stack is Empty");
    return _lst.last;
  }

  ///Search element e in Stack starting from Top to Bottom
  @override
  int search(T e) {
    if (isEmpty) throw Exception("Stack is Empty");
    return _lst.lastIndexOf(e);
  }

  ///Push many elements to the top of stack one by one
  void pushMany(Iterable<T> i) {
    _lst.addAll(i);
  }

  @override
  Iterator<T> get iterator => _lst.reversed.iterator;

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write("- TOP -\n");
    sb.writeAll(_lst.reversed, "\n");
    sb.write("\n- BASE -");
    return sb.toString();
  }
}

void main() {
  var stack = StackViaList<int>(firstItem: 1);
  stack.push(2);
  stack.push(3);
  stack.pushMany([4, 5, 6]);
  print(stack.pop());
  print(stack.peek());
  for (var e in stack) {
    print(e);
  }
  print(stack);
}
