import 'package:tictactoe/models/game.dart';

String? checkWinner(List<Point?> board) {
  const winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var combo in winningCombinations) {
    if (board[combo[0]] != null &&
        board[combo[0]] == board[combo[1]] &&
        board[combo[1]] == board[combo[2]]) {
      return board[combo[0]]?.name;
    }
  }

  return null;
}

int getGridIdFromWinCombination(List<Point?> board) {
  const winningCombinations = [
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var i = 0; i < winningCombinations.length; i++) {
    var combo = winningCombinations[i];
    if (board[combo[0]] != null &&
        board[combo[0]] == board[combo[1]] &&
        board[combo[1]] == board[combo[2]]) {
      return i + 1;
    }
  }

  return 0;
}

bool checkEndGame(List<Point?> board) {
  for (var point in board) {
    if (point == null) {
      return false;
    }
  }

  return true;
}
