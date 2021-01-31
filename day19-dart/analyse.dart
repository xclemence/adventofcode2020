import 'rule.dart';

class AnalyseResult {
  Map<int, Rule> rules;
  List<String> values;

  AnalyseResult(this.rules, this.values) {}
}

Rule getRule(String line) {
  if (line.contains('"')) {
    return getValueRule(line);
  }

  return getGroupRule(line);
}

Rule getValueRule(String line) {
  const valueExtractor = r'(\d+): "(a|b)"';
  final regExp = new RegExp(valueExtractor);
  final match = regExp.allMatches(line).first;

  return new ValueRule(int.parse(match.group(1)), match.group(2));
}

Rule getGroupRule(String line) {
  const linkExtractor = r'(\d+): (.*)';
  final regExp = new RegExp(linkExtractor);
  var match = regExp.allMatches(line).first;

  final values = match
      .group(2)
      .split("|")
      .map((e) => e.split(" ").where((e) => !e.isEmpty).map((e) {
            return int.parse(e);
          }).toList());

  return new GroupRule(int.parse(match.group(1)), values.toList());
}

AnalyseResult analyseInput(List<String> inputs) {
  var readRules = true;
  final result = new AnalyseResult({}, []);

  for (final line in inputs) {
    if (line.isEmpty) {
      readRules = false;
      continue;
    }

    if (readRules) {
      final rule = getRule(line);
      result.rules[rule.id] = rule;
    } else
      result.values.add(line);
  }

  return result;
}
