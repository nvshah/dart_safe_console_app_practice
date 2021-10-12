import 'dart:math';

///ABFDCE
void microTask(){
  print("A");
  print('B');
  Future((){
    Future(() => print("C"));
    Future.microtask(() => print('D'));
    Future(() => print("E"));
  });
  print("F");
}

///ABFCDE
void normalTask(){
  print("A");
  print('B');
  Future((){
    Future(() => print("C"));
    Future(() => print('D'));
    Future(() => print("E"));
  });
  print("F");
}

main() {
  print('#1 - sqrt(4) -> ${sqrt(4)}');
  print('#2 - mult(4,4) -> ${4 * 4}');
  print('#3 - sum(4, 8) -> ${4 + 8}');
  Future.delayed(
      Duration(seconds: 2), () => print('#4 - mult(4,2) -> ${4 * 2}'));
  print('#5 - diff(8,3) -> ${8-3}');
}
