import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/board.dart';

class TicTacToeGame extends StatefulWidget {
  final int size;
  TicTacToeGame(this.size);
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {

  Widget get _title {
    return Container(
      child: Text("Tic Tac Toe"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [_title, Expanded(child: TicTacToeBoard(widget.size))],
        ),
      ),
    );
  }
}
