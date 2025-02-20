import 'package:flutter/material.dart';
import 'package:tictactoe/l10n/l10n.dart';
import 'package:tictactoe/providers/score_provider.dart';
import 'package:tictactoe/theme/colors.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key, required this.score});

  final Score score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Column(
          children: [
            Text("×",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: GameColors.xColor)),
            Text(translate(context).ticTacToeScoreCountMessage(score.xPoints),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: GameColors.xColor)),
          ],
        ),
        Column(
          children: [
            Text('o',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: GameColors.oColor)),
            Text(translate(context).ticTacToeScoreCountMessage(score.oPoints),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: GameColors.oColor)),
          ],
        ),
      ],
    );
  }
}
