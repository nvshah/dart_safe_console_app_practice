import 'dart:async';

Future<void> futureMany() async {
  var f1 = Future.delayed(Duration(seconds: 10), (){
    return 1;
  });
  var f2 = Future.delayed(Duration(seconds: 5), (){
    return 2;
  });

  var res = await Future.wait<int>([f1, f2]);

  print(res);  // [1, 2]
}

Future<void> futureError()async{
  try{
    var f = await Future.error("sds");
  } catch(e){
    print(e);
  }
}

main() {
 //  futureMany();
  futureError();
}