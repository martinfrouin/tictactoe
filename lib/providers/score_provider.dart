import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/constants/game.dart';

class Score {
  Score({
    required this.xPoints,
    required this.oPoints,
    required this.drawPoints,
  });

  final int xPoints;
  final int oPoints;
  final int drawPoints;
}

class ScoreNotifier extends ChangeNotifier {
  int xPoints = 0;
  int oPoints = 0;
  int drawPoints = 0;

  void incrementScore(String? winner) {
    if (winner == xPlayer) {
      xPoints++;
    } else if (winner == oPlayer) {
      oPoints++;
    } else {
      drawPoints++;
    }

    notifyListeners();
  }

  Score get score =>
      Score(xPoints: xPoints, oPoints: oPoints, drawPoints: drawPoints);
}

final scoreProvider = Provider<ScoreNotifier>((ref) {
  return ScoreNotifier();
});
