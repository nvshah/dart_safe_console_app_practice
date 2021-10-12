class Stack<T> {
  final List<T> _l = [];

  T? get peak => _l.isNotEmpty ? _l.last : null;
  int get size => _l.length;

  bool get canPop => _l.isNotEmpty;
  T? pop() {
    if (!canPop) {
      return null;
    }
    var last = _l.last;
    _l.removeLast();
    return last;
  }
  void push(T v) => _l.add(v);
  void pushMany(Iterable<T> i) => _l.addAll(i);
}
