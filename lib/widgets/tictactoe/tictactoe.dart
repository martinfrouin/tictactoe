import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/models/game.dart';
import 'package:tictactoe/providers/score_provider.dart';

class TicTacToe extends ConsumerStatefulWidget {
  const TicTacToe({super.key});

  @override
  ConsumerState<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends ConsumerState<TicTacToe> {
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

  RiveAnimation grid = RiveAnimation.asset(
    'lib/assets/rive/grid.riv',
    fit: BoxFit.contain,
  );

  List<Point?> board = List.filled(9, null);
  bool isX = true;
  String? winner;
  bool isEnded = false;

  void _handleTap(int index, WidgetRef ref) {
    if (board[index] == null) {
      setState(() {
        board[index] = isX ? xMove : oMove;
        isX = !isX;
        winner = checkWinner(board);
        isEnded = checkEndGame(board);
      });

      if (isEnded || winner != null) {
        ref.read(scoreProvider).incrementScore(winner);
      }
    }
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, null);
      isX = true;
      winner = null;
      isEnded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Score score = ref.read(scoreProvider).score;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Column(
              children: [
                Text("×",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.blue)),
                Text("${score.xPoints} wins",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.blue)),
              ],
            ),
            Column(
              children: [
                Text("o",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.red)),
                Text("${score.oPoints} wins",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            children: [
              Positioned(child: grid),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                shrinkWrap: true,
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index, ref),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Center(
                        child: board[index]?.animation ?? SizedBox(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (isEnded || winner != null)
          Text(winner != null ? '$winner has won!' : 'It\'s a draw!'),
        const SizedBox(height: 20),
        if (isEnded || winner != null)
          ElevatedButton(
            onPressed: resetGame,
            child: Text("Reset"),
          ),
      ],
    );
  }
}
