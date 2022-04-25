class A{
  int a;
  A([this.a = 10]);
}

class B extends A{
  int b;
  @override
  int a = 1;
  B([this.b = 20]);
}

A getFamilyA(){
  return B();
}

main() {
  dynamic o1 = getFamilyA();
  var t1 = o1 as A;
  print(t1.a); // 1
  var t2 = o1 as B;
  print('${t2.a}, ${t2.b}');  // 1 20
}