import 'package:intl/intl.dart';
import 'dart:math';

import 'package:intl/locale.dart';
import 'package:number_display/number_display.dart';

import 'package:numeral/numeral.dart';

extension numberOrdinal on int {
  String ordinalSuffix() {
    final formattedNum = ordinal(this)!;
    return formattedNum.substring(formattedNum.length - 2);
  }

  /// 1000 -> 1K
  String toCompactValue({int fractionalDigits = 2}) {
    return Numeral(this).value(fractionDigits: fractionalDigits);
  }
}

/// Convert an integer to its ordinal as a string. 1 is '1st', 2 is '2nd',
/// 3 is '3rd', etc. works for any integer.
String? ordinal(int value) {
  int tempValue;
  dynamic templates;
  String? finalValue;

  List valueSpecial = [11, 12, 13];

  if (valueSpecial.contains(value % 100)) {
    return "${value}th";
  } else if (value.toString().length == 1) {
    templates = [
      "0",
      "1st",
      "2nd",
      "3rd",
      "4th",
      "5th",
      "6th",
      "7th",
      "8th",
      "9th",
    ];
    finalValue = templates[value];
  } else {
    tempValue = value % 10;
    templates = {
      // Ordinal format when value ends with 0, e.g. 80th
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 1, e.g. 81st, except 11.
      "$tempValue": "${value}st",
      // Ordinal format when value ends with 2, e.g. 82nd, except 12.
      "$tempValue": "${value}nd",
      // Ordinal format when value ends with 3, e.g. 83rd, except 13.
      "$tempValue": "${value}rd",
      // Ordinal format when value ends with 4, e.g. 84th.
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 5, e.g. 85th.
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 6, e.g. 86th.
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 7, e.g. 87th.
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 8, e.g. 88th.
      "$tempValue": "${value}th",
      // Ordinal format when value ends with 9, e.g. 89th.
      "$tempValue": "${value}th",
    };
    finalValue = templates["$tempValue"];
  }
  return finalValue;
}

/// 1000 -> 1K
String toCompactValue(num n) {
  final nf = NumberFormat.compact();
  //final nf = NumberFormat("###.##";
  //nf.minimumExponentDigits = 3;
  //nf.maximumFractionDigits = 2;
  //nf.minimumFractionDigits = 3;
  //nf.maximumIntegerDigits = 10;
  return nf.format(n);
}

/**
 * Create Compact Repr of number i.e for given floating point bound
 */
String toCompactNum(num n, {int floatingPointAccuracy=2}) {
  var nWithOrdinal = Numeral(n).value();
  final pattern = r"^(?:(?<whole>\d*)\.?(?<fraction>\d*))(?<ordinal>.?)$";
  //final pattern = r"^(\d+\.?\d*)(.?)$";
  var match = RegExp(pattern).firstMatch(nWithOrdinal);
  if (match == null) {
    throw 'Incorrect Number';
  }
  var wholePart = match.namedGroup("whole") ?? '';
  var fractionPart = match.namedGroup("fraction") ?? '';
  var ordinal = match.namedGroup("ordinal") ?? '';
  var fractionNum = int.tryParse(fractionPart) ?? 0;
  if(fractionNum > 0){
    //fractionPart = formatNum1(double.parse('.$fractionNum'), decimalBy: floatingPointAccuracy);
    fractionPart = removeAllTrailingZeros(double.parse(double.parse('.$fractionNum').toStringAsFixed(floatingPointAccuracy))).toString();
  }
  return '$wholePart$fractionPart$ordinal';
  // var numPart = double.tryParse(match.group(1)!) ?? 0;
  // var ordinal = match.group(2) ??'';
  // var fnum = num.parse(numPart.toStringAsFixed(2));
  // return '$fnum$ordinal';
}

/**
 * Format Ndecimal number esp to round the digits after floating (decimal) point
 */
String formatNum1(num n, {int decimalBy = 2}) {
  final nf = NumberFormat(".${'#' * decimalBy}");
  return nf.format(n);
}

num removeAllTrailingZeros(num n){
  if(n % 1 == 0){
    return n.toInt();
  }
  return n;
}

String number_display(num n, {int decimalAccuracy=2}){
  final display = createDisplay(decimal: decimalAccuracy);
  return display(n);
}

class NumUtils{
  static String divider(num n) {
    if (n >= 1000000000000) {
      return parser(n, 1000000000000, 'T');
    } else if (n >= 1000000000) {
      return parser(n, 1000000000, 'B');
    } else if (n >= 1000000) {
      return parser(n, 1000000, 'M');
    } else if (n >= 1000) {
      return parser(n, 1000, 'K');
    } else {
      return n.toString();
    }
  }

  static String parser(num n, int divider, String char) {
    return num.parse((n / divider).toStringAsFixed(2)).toString() + char;
  }
}

void main() {
  int n = 1878843;
  var n2 = 102022;
  print(toCompactValue(n2));

  print(Numeral(n2).value(fractionDigits: 2));

  print('Proper Compact :- ${toCompactNum(0.2349)}');

  print(number_display(202000));

  num n5 = 20.00;
  print(double.parse('.53000'));

  print(NumUtils.divider(2000));

  print(0.50000.toStringAsFixed(2));

  // print(formatNum1(.352));
  //
  // print('s' * 3);

}
