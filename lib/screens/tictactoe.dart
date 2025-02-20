import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:tictactoe/helpers/game.dart';
import 'package:tictactoe/l10n/l10n.dart';
import 'package:tictactoe/models/game.dart';
import 'package:tictactoe/providers/score_provider.dart';
import 'package:tictactoe/theme/colors.dart';
import 'package:tictactoe/widgets/scoreboard.dart';

class TicTacToeScreen extends ConsumerStatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  ConsumerState<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends ConsumerState<TicTacToeScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context).ticTacToeTitle),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Scoreboard(score: score),
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
                                ? (winner == 'o'
                                    ? GameColors.oColor
                                    : GameColors.xColor)
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
      ),
    );
  }
}
