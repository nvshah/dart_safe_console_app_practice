class Tuple<E extends num> {
  final E? _a;
  final E? _b;
  final E? _c;

  const Tuple(this._a, this._b, this._c);

  Tuple.fromList(List<E> l)
      : _a = l.length != 0 ? l[0] : null,
        _b = l.length >= 2 ? l[1] : null,
        _c = l.length >= 3 ? l[2] : null;

  E? get first => _a;
  E? get second => _b;
  E? get third => _c;

  Tuple<num> operator +(Tuple<num> t){
    if(this is Tuple<num>){
      final tAsN = this as Tuple<num>;
      return Tuple(_a! + t._a!, _b! + t._b!, _c! + t._c!);
    }
    return Tuple(0, 0, 0);
  }

  Tuple<num> operator -(Tuple<num> t){
    if(this is Tuple<num>){
      final tAsN = this as Tuple<num>;
      return Tuple(_a! - t._a!, _b! - t._b!, _c! - t._c!);
    }
    return Tuple(0, 0, 0);
  }

  @override
  String toString() {
    return '($_a, $_b, $_c)';
  }
}

void main(){
  var t1 = Tuple.fromList(<int>[1, 2, 3]);
  var t2 = Tuple.fromList(<double>[4.0, 5.0, 6.0]);
  var tsum = t1+t2;
  var tdiff = t1-t2;
  print('sum:- $tsum, diff :- $tdiff');
}
