class A{
  int a = 10;
  void m1() => print("A -> m1() $a");

  A(int a){
    print("A Constructor is called by ${this.runtimeType}");
    this.a = 100;
  }
}

//Q!! Why class with `Object` Name is Allowed to be define
class Object{
  Object(){
    print("Object is Called by ${this.runtimeType}");
  }
}

class B implements A{
  //super() will make call to Object
  B():super();

  @override
  int a = 30;

  @override
  void m1() {
    print("B -> m1() $a");
  }

  A(int a){
    this.a = a;
  }
}

class C extends A{
  C():super(20);

  A(){
    print("A from C");
  }
}

void main() {
  A b = B();
  A c = C();

  b.m1();
  c.m1();

  Object d = Object();
}