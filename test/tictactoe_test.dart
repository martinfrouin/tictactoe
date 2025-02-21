import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/models/game.dart';

void main() {
  Point xMove = Point(
    name: '×',
    animation: const SizedBox(),
  );

  Point oMove = Point(
    name: 'o',
    animation: const SizedBox(),
  );

  test('Check winner and end game when no points are given', () {
    List<Point?> board = List.filled(9, null);

    String? winner = checkWinner(List.filled(9, null));
    bool isEnded = checkEndGame(board);

    expect(winner, null);
    expect(isEnded, false);
  });

  test('Check winner and end game when multiple points are given', () {
    List<Point> board = [
      xMove,
      oMove,
      xMove,
      oMove,
      xMove,
      oMove,
      xMove,
      oMove,
      xMove,
    ].toList();

    bool isEnded = checkEndGame(board);
    String? winner = checkWinner(board);
    int gridId = getGridIdFromWinCombination(board);

    expect(isEnded, true);
    expect(winner, "×");
    expect(gridId, 7);
  });

  test('Check end game and winner when some points are given', () {
    List<Point?> board = [
      xMove,
      xMove,
      null,
      oMove,
      oMove,
      null,
      null,
      null,
      null,
    ].toList();

    bool isEnded = checkEndGame(board);
    String? winner = checkWinner(board);

    expect(isEnded, false);
    expect(winner, null);
  });
}
