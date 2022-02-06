import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/board.dart';
import 'package:tictactoe/data/board_data.dart';

class TicTacToeGame extends StatefulWidget {
  final int size;
  TicTacToeGame(this.size);
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  Key _boardKey = UniqueKey();
  TicTacToeWinData? win;
  Widget get _title {
    return Container(
      child: Text("Tic Tac Toe", style: TextStyle(fontSize: 23)),
    );
  }

  String get _backgroundImageUrl {
    return "";
  }

  void onWinOrDraw(TicTacToeWinData win, TicTacToeBoardData boardData) {
    setState(() {
      this.win = win;
    });
  }

  DecorationImage get _backgroundImage {
    return DecorationImage(
        image: Image.network(
      _backgroundImageUrl,
      fit: BoxFit.cover,
    ).image);
  }

  Widget _winAlert() {
    TicTacToeWinData winData = win as TicTacToeWinData;
    return Positioned.fill(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Expanded(
              child: FractionallySizedBox(
                  widthFactor: 0.3,
                  heightFactor: 0.5,
                  child: Card(
                    child: FittedBox(
                        child: Text(winData.draw
                            ? "Draw!"
                            : "Winner: ${winData.winner}!")),
                  )))
        ]));
  }

  Widget get _controlPanel {
    return Container(
        decoration: BoxDecoration(color: Colors.black54),
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _boardKey = UniqueKey();
                      win = null;
                    });
                  },
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(
                        Icons.replay_outlined,
                      )),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                )),
            Expanded(child: Container(), flex: 18)
          ],
        ));
  }

  Widget get _board {
    return Stack(children: [
      Positioned.fill(
          child: TicTacToeBoard(
        widget.size,
        key: _boardKey,
        onWin: onWinOrDraw,
      )),
      if (win != null) ...[_winAlert()]
    ]);
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
