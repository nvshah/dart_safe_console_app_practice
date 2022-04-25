import 'package:collection/collection.dart' as collect;
class MapUtils{
  /// Compare 2 Maps object (regardless of their elements order)
  static bool isEqual(m1, m2){
    return collect.DeepCollectionEquality.unordered().equals(m1, m2);
  }
}