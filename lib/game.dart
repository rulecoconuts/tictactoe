import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/board.dart';

class TicTacToeGame extends StatefulWidget {
  final int size;
  TicTacToeGame(this.size);
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  Key _boardKey = UniqueKey();
  Widget get _title {
    return Container(
      child: Text("Tic Tac Toe"),
    );
  }

  String get _backgroundImageUrl {
    return "";
  }

  DecorationImage get _backgroundImage {
    return DecorationImage(
        image: Image.network(
      _backgroundImageUrl,
      fit: BoxFit.cover,
    ).image);
  }

  Widget get _controlPanel {
    return Container(
        decoration: BoxDecoration(color: Colors.black54),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                setState(() {
                  _boardKey = UniqueKey();
                });
              },
              child: Icon(
                Icons.replay_outlined,
                size: 40,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
            )
          ],
        ));
  }

  Widget get _board {
    return TicTacToeBoard(widget.size, key: _boardKey,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _title,
            Expanded(
                child: Row(children: [
              Expanded(
                child: _board,
                flex: 8,
              ),
              Expanded(
                child: _controlPanel,
                flex: 1,
              )
            ]))
          ],
        ),
      ),
    );
  }
}
