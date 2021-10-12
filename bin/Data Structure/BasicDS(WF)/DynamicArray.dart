/**
 * Dynamic Array
 */

class DynamicArray<T> extends Iterable<T> {
  late List<T?> _arr;
  int length = 0; // length user thinks array is
  int capacity = 0; // Actual array size possible

  DynamicArray([this.capacity = 16]) {
    if (capacity < 0)
      throw Exception("InAppropriate Capacity, capacity must be > 0");
    _arr = List.filled(capacity, null, growable: false);
    print('Array Initialized with $capacity capacity');
  }

  int get size => length;

  bool get isEmpty => length == 0;

  T get(i) {
    if (i < 0 || i >= length) throw Exception("Invalid Index");
    return _arr[i]!;
  }

  void set(int i, T e) {
    if (i < 0 || i >= length) throw Exception("Invalid Index");
    _arr[i] = e;
  }

  void clear() {
    for (var i = 0; i < length; i++) _arr[i] = null;
    length = 0;
  }

  void add(T e) {
    //Resize require
    if (length + 1 >= capacity) {
      capacity = capacity == 0 ? 1 : capacity * 2; //double the size
      //// arr has extra nulls padded
      final new_arr = List.generate(
        capacity,
        (i) => i < length ? _arr[i] : null,
        growable: false,
      );
      _arr = new_arr;
    }
    _arr[length++] = e;
  }

  ///remove element at index i
  T removeAt(int i) {
    if (i < 0 || i >= length) throw Exception("Invalid Index");
    T data = _arr[i]!;
    final new_arr = List.generate(
        capacity - 1, (j) => j < i ? _arr[j] : _arr[j + 1],
        growable: false);
    _arr = new_arr;
    //As removing element array is still full so need to change capacity
    capacity = --length;
    return data;
  }

  ///remove object from array
  bool remove(Object o) {
    int idx = find(o);
    if (idx == -1) return false;
    removeAt(idx);
    return true;
  }

  ///find index of object in array
  int find(Object o) {
    for (var i = 0; i < length; i++) {
      if (o == _arr[i]) {
        return i;
      }
    }
    return -1;
  }

  bool includes(Object o) => find(o) != -1;

  @override
  Iterator<T> get iterator => _DynamicArrayIterator(_arr, length);
  
  @override
  String toString() {
    final sb = StringBuffer();
    sb.write("<-| ");
    sb.writeAll(this, ", ");
    sb.write(" |->");
    return sb.toString();
  }
}

class _DynamicArrayIterator<T> extends Iterator<T> {
  late final List<T?> arr;
  int length;

  _DynamicArrayIterator(this.arr, this.length);

  int currentIndex = 0;

  @override
  T get current => arr[currentIndex++]!;

  @override
  bool moveNext() => currentIndex < length;
}

main() {
  final da = DynamicArray<int>();

  da.add(10);
  da.add(20);
  da.add(30);
  da.add(30);

  da.remove(30);

  print(da.toString());
}
