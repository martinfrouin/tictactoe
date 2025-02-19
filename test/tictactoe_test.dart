import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/models/game.dart';

void main() {
  test('Check winner when multiple points are given', () {
    String? winner = checkWinner([
      Point(
        name: '×',
        animation: SizedBox(),
      ),
      Point(
        name: '×',
        animation: SizedBox(),
      ),
      Point(
        name: '×',
        animation: SizedBox(),
      ),
      null,
      null,
      null,
      null,
      null,
      null,
    ]);

    expect(winner, '×');
  });
}
