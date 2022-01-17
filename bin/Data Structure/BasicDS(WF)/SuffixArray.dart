import 'dart:math';

/*
 * ref : https://youtu.be/VpEumOuakOU
 */

class SuffixArray{
  late String text;
  late int n;  // number of entries in suffix array & LCP
  late int l; // original length of text
  // Suffix Array (i -> start of suffix from index i)
  late List<int> sa;
  // Longest Common Prefix Array
  late List<int> lcp;
  // Text Order Array (i -> start of suffix from index i)
  late List<String> toa;
  // Rank Array (Inverse Map of SA)
  late List<int> ra;

  SuffixArray.builder(String txt){
    text = txt+'\$';  // add $ -> (EOL)
    n = text.length;  // +1 for empty string
    l = n-1;         // actual length of text
    sa = List.filled(n, -1);
    lcp = List.filled(n, 0);
    ra = List.filled(n, -1);

    _build_TOA();
  }

  void _build_TOA(){
    toa = [for(var l in List.generate(n, (i) => i)) text.substring(l, n)];
    print('TOA : $toa');
  }

  List<int> build_SA(){
    // SA will hold starting index of substr
    var indexes = List.generate(n, (i) => i);
    indexes.sort((a,b) => toa[a].compareTo(toa[b]));
    sa = indexes;
    print('SA :- $sa');
    return sa;
  }

  void _build_RA(){
    // Inverse mapping of Suffix array
    for(var i=0; i<n; i++){
      ra[sa[i]] = i;
    }
    print('RA :- $ra');
  }

  List<int> build_LCP(){
    _build_RA();
    kasai_algo();  // kasai algo is used to build lcp
    print('LCP :- $lcp');
    return lcp;
  }

  /// find the common prefix length from index -> {startfFrom} between 2 strings
  int common_prefix(String s1, String s2, {int startFrom = 0}){
    int minLen = min(s1.length, s2.length);
    int len = 0;
    if(startFrom < minLen){
      for(var i=startFrom; i<minLen; i++){
        //print('${s1[i]} ${s2[i]}');
        if(s1[i] != s2[i]) return len;
        len++;
      }
    }
    return len;
  }

  ///Use kasai algo to build LCP
  void kasai_algo(){
    /*
     * Compute LCP in Text Order rather than Suffix Array Order
     * (ie in Some Random Order)
     * Make use of Previous Comparison to avoid spending on next Time !
     */

    int prev = 0;  // #Match found in earlier checking already that will satisfy next pairs of texts
    for(var i=0; i<n-1; i++){
      var rank = ra[i];
      var txt_c = toa[i];   // current text
      var txt_p = toa[sa[rank-1]];  // prev text (according to rank)

      //print(txt_c + ' ' + txt_p);

      // Common prefix from 0 -> prev, so search from index prev
      var len = common_prefix(txt_c, txt_p, startFrom: prev);
      var commonLen = len + prev;
      //print('result commmon_prefix() :- ${commonLen}');
      lcp[rank] = commonLen;
      prev = commonLen-1 > 0 ? commonLen - 1 : 0;
      //print('Prev :- $prev');
    }
  }

  List<int> get suffixArray => sa;
  List<int> get longestCommonPrefixArray => lcp;

  int get numUniqueSubStr => ((l*(l+1))~/2) - lcp.reduce((a, b) => a + b);
  int get textLength => l;
}

main() {
  var s = 'bananaban';
  s = 'azaza';
  var sab = SuffixArray.builder(s);
  var a1 = sab.build_SA();
  var a2 = sab.build_LCP();
  print(sab.numUniqueSubStr);
}
