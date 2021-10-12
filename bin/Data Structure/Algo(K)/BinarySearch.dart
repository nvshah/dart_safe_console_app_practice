/**
 * Order Agnostic Binary Search (NonDecreasing Or NonIncreasing)
 */

int binarySearch(
  List<int> arr,
  int toBeSearch, {
  bool priorLeftMost = false,
  bool priorRightMost = false,
}) {
  if (priorRightMost && priorLeftMost)
    throw Exception("Cannot Priortize LeftMost & RightMost at same time");
  if (arr.isEmpty) throw Exception("Array is Empty");
  bool nonDecreasing = true;

  if (arr[0] > arr[arr.length - 1]) {
    nonDecreasing = false;
  } else if (arr[0] == arr[arr.length - 1] && arr[0] == toBeSearch) {
    if (priorRightMost) return arr.length - 1;
    return 0;
  }

  int start = 0;
  int end = arr.length - 1;
  int complexity = 0;
  int ans = -1;

  if (nonDecreasing) {
    while (start <= end) {
      complexity += 1;
      // middle = (2*start + end - start)/2 = (end + start)/2
      int mid = start + ((end - start) ~/ 2);
      int val = arr[mid];
      if (toBeSearch < val) {
        //Search in Left part
        end = mid - 1;
      } else if (toBeSearch > val) {
        //Search in right part
        start = mid + 1;
      } else {
        ans = mid;
        break;
      }
    }
  } else {
    while (start <= end) {
      complexity += 1;
      // middle = (2*start + end - start)/2 = (end + start)/2
      int mid = start + ((end - start) ~/ 2);
      int val = arr[mid];
      if (toBeSearch > val) {
        //Search in Left part
        end = mid - 1;
      } else if (toBeSearch < val) {
        //Search in right part
        start = mid + 1;
      } else {
        ans = mid;
        break;
      }
    }
  }
  print("Complexity (mid counts) -> $complexity");

  if (priorLeftMost) {
    int trav = ans - 1;
    while (trav >= 0) {
      if (arr[trav] != toBeSearch)
        break;
      else {
        ans = trav;
        trav -= 1;
      }
    }
  } else if (priorRightMost) {
    int trav = ans + 1;
    while (trav < arr.length) {
      if (arr[trav] != toBeSearch)
        break;
      else {
        ans = trav;
        trav += 1;
      }
    }
  }

  return ans;
}

main() {
  var arr = [2, 4, 5, 10, 20, 33, 33, 33, 40, 50];
  arr = [1];
  arr = [100, 90, 80, 80, 76, 75, 40, 30];
  final ans = binarySearch(arr, 40, priorLeftMost: true, priorRightMost: false);

  print(ans);
}
