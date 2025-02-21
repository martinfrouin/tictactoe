import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:tictactoe/constants/game.dart';
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
    name: xPlayer,
    animation: RiveAnimation.asset(
      'lib/assets/rive/cross.riv',
      fit: BoxFit.contain,
    ),
  );

  Point oMove = Point(
    name: oPlayer,
    animation: RiveAnimation.asset(
      'lib/assets/rive/circle.riv',
      fit: BoxFit.contain,
    ),
  );

  RiveAnimation grid = RiveAnimation.asset(
    'lib/assets/rive/grid.riv',
    fit: BoxFit.contain,
    behavior: RiveHitTestBehavior.translucent,
    onInit: _onGridInit,
    stateMachines: ['Grid Machine', 'Win Machine'],
    speedMultiplier: 2,
  );

  RiveAnimation turnIndicator = RiveAnimation.asset(
    'lib/assets/rive/turn_indicator.riv',
    fit: BoxFit.contain,
    behavior: RiveHitTestBehavior.translucent,
    onInit: _onTurnIndicatorInit,
    speedMultiplier: 2,
  );

  List<Point?> board = List.filled(9, null);
  bool isX = true;
  String? winner;
  bool xStarts = true;
  bool isEnded = false;

  static late StateMachineController _gridController;
  static late StateMachineController _turnIndicatorController;

  static void _onGridInit(Artboard artboard) {
    _gridController = StateMachineController.fromArtboard(
      artboard,
      'Win Machine',
    )!;

    artboard.addController(_gridController);
  }

  static void _onTurnIndicatorInit(Artboard artboard) {
    _turnIndicatorController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    )!;

    artboard.addController(_turnIndicatorController);
  }

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

      _turnIndicatorController.getBoolInput('isX')!.value = isX;

      if (isEnded || winner != null) {
        int id = getGridIdFromWinCombination(board);
        _gridController.inputs.first.value = id.toDouble();
        ref.read(scoreProvider).incrementScore(winner);
      }
    }
  }

  void resetGame() {
    _turnIndicatorController.getBoolInput('isX')!.value = !xStarts;
    _gridController.inputs.first.value = 0.toDouble();

    setState(() {
      board = List.filled(9, null);
      isX = !xStarts;
      xStarts = !xStarts;
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
                const SizedBox(height: 16),
                if (isEnded || winner != null)
                  Text(
                    winner != null
                        ? translate(context).ticTacToeWinnerMessage(winner!)
                        : translate(context).ticTacToeDrawMessage,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: winner != null
                              ? (winner == oPlayer
                                  ? GameColors.oColor
                                  : GameColors.xColor)
                              : Colors.white,
                        ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              children: [
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
                Positioned(child: grid),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: Center(
                    child: turnIndicator,
                  ),
                ),
                const SizedBox(height: 16),
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
