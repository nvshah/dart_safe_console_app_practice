var m = [[1,-1], [-2,4]];
void main(){
  outer:
  for (var i = 0; i < m.length; i++) {
    inner:
    for (var j = 0; j < m[i].length; j++) {
      if (m[i][j] < 0) {
        print("Negative value found at $i,$j: ${m[i][j]}");
        break outer;
      }
    }
  }

  print('Here it is !');
}
