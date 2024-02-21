import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

// Style style = FlatStyle(
//   primaryColor: Color(0xffd97706),
//   backgroundColor: Color(0xff03111a),
// );

Style style = FlatStyle(
  primaryColor: Color(0xff287ac5),
  backgroundColor: Color(0xff09090b),
);


Color getCentsColor(int? amountCents) {
  if (amountCents == null || amountCents == 0) {
    return Colors.white;
  }
  if (amountCents > 0) {
    return Colors.green;
  }
  return Colors.red;
}
