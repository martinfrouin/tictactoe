import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/l10n/l10n.dart';
import 'package:tictactoe/models/game.dart';
import 'package:tictactoe/providers/score_provider.dart';

class TicTacToe extends ConsumerStatefulWidget {
  const TicTacToe({super.key});

  @override
  ConsumerState<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends ConsumerState<TicTacToe> {
  Point xMove = Point(
    name: '×',
    animation: RiveAnimation.asset(
      'lib/assets/rive/cross.riv',
      fit: BoxFit.contain,
    ),
  );

  Point oMove = Point(
    name: 'o',
    animation: RiveAnimation.asset(
      'lib/assets/rive/circle.riv',
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
  final xColor = Colors.blue;
  final oColor = Colors.pink[300];

  void _handleTap(int index, WidgetRef ref) {
    if (isEnded || winner != null) {
      return;
    }

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
        Expanded(
          child: Column(
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
                              ?.copyWith(color: xColor)),
                      Text(
                          translate(context)
                              .ticTacToeScoreCountMessage(score.xPoints),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: xColor)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('o',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: oColor)),
                      Text(
                          translate(context)
                              .ticTacToeScoreCountMessage(score.oPoints),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: oColor)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
                      padding: EdgeInsets.all(16),
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEnded || winner != null)
                Text(
                    winner != null
                        ? translate(context).ticTacToeWinnerMessage(winner!)
                        : translate(context).ticTacToeDrawMessage,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: winner != null
                              ? (winner == 'o' ? oColor : xColor)
                              : Colors.white,
                        )),
              const SizedBox(height: 16),
              if (isEnded || winner != null)
                ElevatedButton(
                  onPressed: resetGame,
                  child: Text(translate(context).ticTacToeResetButton),
                ),
            ],
          ),
        )
      ],
    );
  }
}
