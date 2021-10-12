import '../Collections/list_utils.dart';
//import 'package:trotter/trotter.dart';
import 'package:chitose/chitose.dart';

//Assuming all same elements are already mapped between list l1 & l2
//So no equal item lies in both of the list

/**
 * Why DP is not used ??
 * -> because in this approach we do not require memoizing value being used again
 *    as once we found we are eliminating those values from l1 list for next considerations.
 */

Map<int, int> _segregationMapping(List<num> l1, List<num> l2) {
  Map<int, int> m = {};
  final l1_c = [...l1];
  final l1_c2 = [...l1].where((e) => !e.isNegative).toList();
  int l2_p = 0;
  while (l2_p < l2.length) {
    if (l2[l2_p].isNegative) {
      l2_p++;
      continue;
    }
    var invovling_m = l1_c2.where((e) => e < l2[l2_p]).toList();
    if (invovling_m.length > 1) {
      OUTER:
      for (var i = 2; i <= invovling_m.length; i++) {
        //var pairs = invovling_m.combinations(i).iterable;
        var pairs = getAllCombinationsFor<int>(invovling_m.cast<int>(), r:i);
        for (var pair in pairs) {
          var total = ListUtils.sum(pairs.cast<num>());
          if (total == l2[l2_p]) {
            var idxs = pair.map((e) => l1_c.indexOf(e)).toList();
            idxs.forEach((i) {
              m[i] = l2_p;
              l1_c2.remove(l1_c[i]);
              l1_c[i] = -1;
            });
            break OUTER;
          }
        }
      }
    }
    l2_p++;
  }
  return m;
}

Map<int, int> _getSegregationMapping(List<int> lst1, List<int> lst2) {
  //1. equal items between 2 lists

  var m1 = ListUtils.equalityMapping(lst1, lst2);

  var p_l1_c = [...lst1];
  var p_l2_c = [...lst2];

  if (m1.isNotEmpty) {
    for (var e in m1.entries) {
      p_l1_c[e.key] = -1;
      p_l2_c[e.value] = -1;
    }
  }

  //2. Calculate possible grouping

  var l1 = p_l1_c;
  var l2 = p_l2_c;

  Map<int, int> m2 = {};
  final l1_c = [...l1];
  final l1_c2 = [...l1].where((e) => !e.isNegative).toList();

  int l2_p = 0;
  while (l2_p < l2.length) {
    if (l2[l2_p].isNegative) {
      l2_p++;
      continue;
    }
    var l1_elig_items = l1_c2.where((e) => e < l2[l2_p]).toList();
    if (l1_elig_items.length > 1) {
      OUTER:
      for (var i = 2; i <= l1_elig_items.length; i++) {
        var pairs = getAllCombinationsFor(l1_elig_items, r: i);
        for (var pair in pairs) {
          var total = ListUtils.sum(pair);
          if (total == l2[l2_p]) {
            //var idxs = pair.map((e) => l1_c.indexOf(e)).toList();
            pair.forEach((e) {
              var i = l1_c.indexOf(e);
              m2[i] = l2_p;
              l1_c2.remove(l1_c[i]);
              l1_c[i] = -1;
            });
            // idxs.forEach((i) {
            //   m2[i] = l2_p;
            //   l1_c2.remove(l1_c[i]);
            //   l1_c[i] = -1;
            // });
            break OUTER;
          }
        }
      }
    }
    l2_p++;
  }
  return {...m1, ...m2};
}

List<List<T>> getAllCombinationsFor<T>(List<T> l, {int r = -1}) {
  if (r < 0 || r > l.length) {
    return l.subs();
  }
  //return l.combinations(i).iterable;
  return l.combs(r);
}

void main() {
  //var l1 = [28, 980, 1304, 1578, 2318];
  //var l2 = [1008, 5200];

  var l1, l2 = <int>[];

  l1 = <int>[4, 10, 6, 20, 30];
  l2 = <int>[20, 10, 40];

  l1 = <int>[1, 2, 3, 4, 5];
  l2 = <int>[3, 7, 5, 10];

  l1 = <int>[10, 15, 20, 25, 50];
  l2 = <int>[20, 75, 25];

  l1 = <int>[2, 3, 5, 8, 10, 11];
  var l3 = <double>[10.0, 13.0, 8.0, 8.0];

  l1 = <int>[1,2,2,3,3];
  l2 = <int>[4,3,4];

  // var m1 = ListUtils.equalityMapping(l1, l2);
  // print(m1);
  //
  // var l1_c = <int>[...l1];
  // var l2_c = <int>[...l2];
  //
  // if (m1.isNotEmpty) {
  //   for (var e in m1.entries) {
  //     l1_c[e.key] = -1;
  //     l2_c[e.value] = -1;
  //   }
  // }
  //
  // var m2 = _segregationMapping(l1_c, l2_c);

  //print(m2);

  //print(_getSegregationMapping(l1, l3.map((e) => e.toInt()).toList()));
  //print(_getSegregationMapping(l1, l2));
  //print(_getSegregationMapping(l1, l3.cast<num>().cast()));
  print([1,2,34,5].combs(10));
}
