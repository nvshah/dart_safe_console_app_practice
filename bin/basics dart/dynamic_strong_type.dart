void dynamic_to_any() {
  dynamic d = {'1': 1};

  //List<int> l1 = d; // thriow error at run time

  Map<String, dynamic> m1 =
      d; // dynamic can easily get promoted to corresp type without any type cast

  print(m1);
}

void dynamic_and_list() {
  dynamic d0 = [1, 2, 3];
  List<dynamic> ld0 = d0;

  print(ld0);

  dynamic d2 = [
    {
      'k': [
        {'1': 1}
      ]
    }
  ];

  var m1 = d2[0] as Map<String, dynamic>;
  var l2 = m1['k']; // Wrong way
  var o3 = l2 as List<Map<String, dynamic>>;
  print(o3);

  f(l2);
  S.f2(l2);
  // List<dynamic> d3 = [
  //   {'1': 1}
  // ];
  // List<Map<String, dynamic>> a3 = d3 as List<Map<String, dynamic>>;
  // // Throw Err :- List<dynamic> cannot be sybtype of List<Map<String, dynamic>>
  // print(a3);

  dynamic d4 = [
    {'1': 1}
  ];

  f(d4);

  List<Map<String, dynamic>> a4 = d4 as List<Map<String, dynamic>>;

  print(a4);
}

void f(dynamic json) {
  var p = json as List<Map<String, dynamic>>;
  print(p);
}

class S {
  static void f2(dynamic json) {
    print(json.runtimeType);
    var p = json as List<Map<String, dynamic>>;
    print(p);
  }
}

// NOTE :- dynamic can hold any type without any casting

void main(List<String> args) {
  //dynamic_to_any();
  dynamic_and_list();
}
