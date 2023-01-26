import 'package:fyp1/models/item_options.dart';
import 'package:fyp1/shared/constants.dart';

class ScoreCalculation {
  Map<String, dynamic> calcITPScore(List<ItemITP> items) {
    Map<String, dynamic> scores = {};

    const constructs = personalityTraits;
    final factor = constructs.length;
    for (var t = 0; t < factor; t++) {
      double total = 0;
      for (var i = t; i < items.length; i = i + factor) {
        ItemITP item = items[i];
        if (item.selectedAnswer == 'Ya') {
          total++;
        }
      }
      double percentage = total / 10 * 100;
      scores[constructs[t]] = percentage;
    }

    return scores;
  }

  Map<String, dynamic> calcIMKScore(List<ItemIMK> items) {
    Map<String, dynamic> scores = {};

    const constructs = personalityTypes;
    final factor = constructs.length;
    for (var t = 0; t < factor; t++) {
      double total = 0;
      for (var i = t; i < items.length; i = i + factor) {
        ItemIMK item = items[i];
        if (item.selectedAnswer == 'Ya') {
          total++;
        }
      }
      double percentage = total / 10 * 100;
      scores[constructs[t]] = percentage;
    }

    return scores;
  }
}
