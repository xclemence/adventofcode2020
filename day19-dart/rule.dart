import 'dart:math';

Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

class RecursePattern {
  final String itemGroupName;

  final Rule leftRule;
  final Rule rightRule;

  final Rule rule;

  RecursePattern(this.itemGroupName, this.leftRule, this.rightRule, this.rule);

  String appendLevelNumber(int number) => "(${leftRule.matchPattern.pattern}){${number}}(${rightRule.matchPattern.pattern}){${number}}";

  String computeLevel(int number) {
    final pattern = range(2, number).map((e) => appendLevelNumber(e)).join("|");

    return "(${pattern})";
  }

  int minLength(int level) => leftRule.minLength() * level + rightRule.minLength() * level;

  String recursePattern() => "(${leftRule.matchPattern.pattern}){2,}(${rightRule.matchPattern.pattern}){2,}";
}

class RulePattern {
  final List<RecursePattern> recursePattern;
  final String pattern;

  RulePattern(this.pattern, this.recursePattern);
}

abstract class Rule {
  final int id;

  static final Map<int, Rule> cache = {};
  static int checkSizeGroupNameSequence = 0;

  RulePattern _matchPattern;

  Rule(this.id) {
    cache[this.id] = this;
  }

  RulePattern get matchPattern {
    if (_matchPattern != null) return _matchPattern;

    _matchPattern = computePattern();
    return _matchPattern;
  }

  RulePattern computePattern();

  int minLength();

  bool isValid(String message) {
    final regExp = new RegExp('^${matchPattern.pattern}\$');
    final firstAnalyse = regExp.hasMatch(message);

    return firstAnalyse && recuseValidation(message, regExp);
  }

  bool recuseValidation(String message, RegExp regExp) {
    final match = regExp.firstMatch(message);

    for (var recurse in matchPattern.recursePattern) {
      final itemText = match.namedGroup(recurse.itemGroupName);
      if (itemText != null && !validatePattern(message, regExp.pattern, recurse)) return false;
    }

    return true;
  }

  bool validatePattern(String message, String basePattern, RecursePattern pattern) {
    var recurseLevel = 2;

    final toReplace = "(?<${pattern.itemGroupName}>${pattern.recursePattern()})";
    int levelMinSize = pattern.minLength(recurseLevel - 1);

    while (levelMinSize < message.length) {
      final newSearch = pattern.computeLevel(recurseLevel);

      final currentPattern = basePattern.replaceAll(toReplace, newSearch);
      final regExp = new RegExp(currentPattern);

      if (regExp.hasMatch(message)) return true;

      recurseLevel++;
      levelMinSize = pattern.minLength(recurseLevel - 1);
    }

    return false;
  }
}

class ValueRule extends Rule {
  final String value;

  ValueRule(int id, this.value) : super(id);

  RulePattern computePattern() => new RulePattern(value, []);

  int minLength() => 1;
}

class GroupRule extends Rule {
  final List<List<int>> ruleLinks;

  GroupRule(int id, this.ruleLinks) : super(id);

  int minLength() {
    return ruleLinks.map((e) => (e.toList()..remove(id)).map((e) => Rule.cache[e].minLength()).reduce((a, b) => a + b)).reduce(min);
  }

  RulePattern computeGroup(List<int> ids) {
    final usableIds = ids.toList();
    var multiple = false;

    if (usableIds.contains(id)) {
      usableIds.remove(id);
      multiple = true;
    }

    final patterns = usableIds.map((e) => Rule.cache[e].matchPattern).toList();

    if (!multiple) return RulePattern(patterns.map((e) => e.pattern).join(""), patterns.map((e) => e.recursePattern).expand((e) => e).toList());

    if (patterns.length == 1) {
      return RulePattern("(${patterns[0].pattern}){2,}", patterns.map((e) => e.recursePattern).expand((e) => e).toList());
    }

    final itemGroup = "Item${Rule.checkSizeGroupNameSequence++}";

    final recusePattern = new RecursePattern(itemGroup, Rule.cache[usableIds[0]], Rule.cache[usableIds[1]], this);

    return RulePattern("(?<${itemGroup}>${recusePattern.recursePattern()})", [recusePattern, ...(patterns.expand((e) => e.recursePattern))]);
  }

  RulePattern computePattern() {
    final linkPatterns = ruleLinks.map((e) => computeGroup(e)).toList();

    final linkPattern = linkPatterns.map((e) => e.pattern).join("|");
    final groupNames = linkPatterns.expand((e) => e.recursePattern);

    if (ruleLinks.length == 1) return RulePattern(linkPattern, groupNames.toList());

    return RulePattern("(${linkPattern})", groupNames.toList());
  }
}
