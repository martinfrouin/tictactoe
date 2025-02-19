import 'package:flutter/material.dart';
import 'package:tictactoe/widgets/tictactoe/tictactoe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Tic Tac Toe"),
        ),
        backgroundColor: Colors.grey[900],
        body: Center(child: TicTacToe()));
  }
}
