import 'dart:io';
import "dart:async";

import 'analyse.dart';

Future main() async {
  final file = new File('data/test2');
  final lines = await file.readAsLines();
  final item = analyseInput(lines);

  print("analyse file ${file.path}");

  final int lineNumber = item.values.length;
  int index = 1;

  final matchValues = item.values.where((e) {
    print("${index++} / ${lineNumber}");
    return item.rules[0].isValid(e);
  }).toList();

  print("Result: ${matchValues.length}");
}
