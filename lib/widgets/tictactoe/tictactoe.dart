import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/models/game.dart';
import 'package:tictactoe/widgets/tictactoe/dialogs.dart';

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  Point xMove = Point(
    name: 'X',
    animation: RiveAnimation.asset(
      'lib/assets/rive/cross_button.riv',
      fit: BoxFit.contain,
    ),
  );

  Point oMove = Point(
    name: 'O',
    animation: RiveAnimation.asset(
      'lib/assets/rive/circle_button.riv',
      fit: BoxFit.contain,
    ),
  );

  List<Point?> board = List.filled(9, null);
  bool isX = true;

  void _handleTap(int index) {
    if (board[index] == null) {
      setState(() {
        board[index] = isX ? xMove : oMove;
        isX = !isX;
      });

      String? winner = checkWinner(board);
      bool isEnded = checkEndGame(board);

      if (isEnded || winner != null) {
        showDialog(
          context: context,
          builder: (context) => getEndDialog(context, winner, () {
            Navigator.of(context).pop();

            setState(() {
              board = List.filled(9, null);
              isX = true;
            });
          }),
        );
      }
    }
  }

  EdgeInsets getGridMargin(int index) {
    double strokeWidth = 4;

    if (index == 0) {
      return EdgeInsets.only(
          left: 0, top: 0, right: strokeWidth, bottom: strokeWidth);
    } else if (index == 1) {
      return EdgeInsets.only(
          left: strokeWidth, top: 0, right: strokeWidth, bottom: strokeWidth);
    } else if (index == 2) {
      return EdgeInsets.only(
          left: strokeWidth, top: 0, right: 0, bottom: strokeWidth);
    } else if (index == 3) {
      return EdgeInsets.only(
          left: 0, top: strokeWidth, right: strokeWidth, bottom: strokeWidth);
    } else if (index == 4) {
      return EdgeInsets.only(
          left: strokeWidth,
          top: strokeWidth,
          right: strokeWidth,
          bottom: strokeWidth);
    } else if (index == 5) {
      return EdgeInsets.only(
          left: strokeWidth, top: strokeWidth, right: 0, bottom: strokeWidth);
    } else if (index == 6) {
      return EdgeInsets.only(
          left: 0, top: strokeWidth, right: strokeWidth, bottom: 0);
    } else if (index == 7) {
      return EdgeInsets.only(
          left: strokeWidth, top: strokeWidth, right: strokeWidth, bottom: 0);
    } else {
      return EdgeInsets.only(
          left: strokeWidth, top: strokeWidth, right: 0, bottom: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement scoreboard

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          height: 300,
          width: 300,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  margin: getGridMargin(index),
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: board[index]?.animation ?? SizedBox(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
