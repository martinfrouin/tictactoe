import 'package:flutter/material.dart';

AlertDialog getEndDialog(
    BuildContext context, String? winner, VoidCallback onPlayAgain) {
  return AlertDialog(
    title: Text(winner != null ? 'Winner!' : 'Draw!'),
    content: Text(winner != null ? '$winner has won!' : 'It\'s a draw!'),
    actions: [
      TextButton(
        onPressed: onPlayAgain,
        child: Text('Play Again'),
      ),
    ],
  );
}
