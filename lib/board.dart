import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tictactoe/data/board_data.dart';

class TicTacToeBoard extends StatefulWidget {
  int size;
  final void Function(TicTacToeWinData win, TicTacToeBoardData boardData)?
      onWin;
  TicTacToeBoard(this.size, {this.onWin, Key? key}) : super(key: key);
  TicTacToeBoardState createState() => TicTacToeBoardState();
}

class TicTacToeBoardState extends State<TicTacToeBoard> {
  late TicTacToeBoardData boardData;
  late List<List<BoardTile>> tiles;
  String player = "X";
  TicTacToeWinData? winner = null;
  GlobalKey _boardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    boardData = TicTacToeBoardData(widget.size);
    tiles = _initTiles(widget.size);
  }

  ///
  /// Switch player turns
  ///
  void _switchTurns() {
    if (player == "X")
      player = "O";
    else
      player = "X";
  }

  ///
  /// Disable a board tile
  ///
  void _disableTile(BoardTile tile) {
    _BoardTileState tileState =
        (tile.key as GlobalKey).currentState as _BoardTileState;
    tileState.setTouchEnabled(false);
  }

  ///
  /// Disable board
  ///
  void _disableBoard() {
    tiles.forEach((row) {
      row.forEach(_disableTile);
    });
  }

  ///
  /// Set the winner of the game
  ///
  void _setWinner(TicTacToeWinData? winningPlayer) {
    setState(() {
      winner = winningPlayer;
    });
    widget.onWin?.call(winner as TicTacToeWinData, boardData);
  }

  ///
  /// Insert a move on the board data
  ///
  void _insertMove(int row, int column) {
    TicTacToeWinData? winningPlayer = boardData.insert(row, column, player);
    if (winningPlayer != null) {
      _setWinner(winningPlayer);
      _disableBoard();
    } else {
      setState(() {
        _switchTurns();
      });
    }
  }

  Widget _generateTileContent(Widget content) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white10,
                Colors.blueGrey,
              ])),
      child: Column(children:[Expanded(child: content)]),
    );
  }

  ///
  /// Fill tile
  ///
  void _fillTile(int row, int column) {
    BoardTile tile = tiles[row][column];
    _BoardTileState tileState =
        (tile.key as GlobalKey).currentState as _BoardTileState;
    tileState.setContent(_generateTileContent(FractionallySizedBox(heightFactor: 0.5, child: FittedBox(
        fit: BoxFit.cover,
        child: Text(
          player,
        )))));
    tileState.setTouchEnabled(false);
    _insertMove(row, column);
  }

  ///
  /// Initialize a tile row
  ///
  List<BoardTile> _initTileRow(int row, int size) {
    return List.generate(
        size,
        (column) => BoardTile(
              row,
              column,
              _generateTileContent(Container()),
              key: GlobalKey(),
              onTapped: _fillTile,
              touchEnabled: true,
            ),
        growable: false);
  }

  ///
  /// Initialize all the tiles that will be displayed on the board
  ///
  List<List<BoardTile>> _initTiles(int size) {
    return List.generate(size, (row) => _initTileRow(row, size),
        growable: false);
  }

  Widget _getTileRow(int row, int size) {
    return Row(
      children:
          List.generate(size, (column) => Expanded(child: tiles[row][column])),
    );
  }

  ///
  /// Get board
  ///
  Widget get _board {
    return Column(
      children: List.generate(
          widget.size, (row) => Expanded(child: _getTileRow(row, widget.size))),
    );
  }

  ///
  /// Get render box of the tile at the row and column
  ///
  RenderBox _getTileRenderBox(int row, int column) {
    BoardTile tile = tiles[row][column];
    return (tile.key as GlobalKey).currentContext?.findRenderObject()
        as RenderBox;
  }

  ///
  /// Get start position of winning line
  ///
  Offset _getWinningLineStart(TicTacToeWinData? winData) {
    TicTacToeWinData toeWinData = winData as TicTacToeWinData;
    if (toeWinData.winningMethod == "left-diagonal") {
      RenderBox renderBox =
          _getTileRenderBox(boardData.topLeft.row, boardData.topLeft.column);
      return renderBox.localToGlobal(Offset.zero);
    }
    if (toeWinData.winningMethod == "right-diagonal") {
      RenderBox renderBox =
          _getTileRenderBox(boardData.topRight.row, boardData.topRight.column);
      return renderBox.localToGlobal(Offset(renderBox.size.width, 0));
    }
    if (toeWinData.winningMethod == "row") {
      RenderBox renderBox = _getTileRenderBox(toeWinData.row as int, 0);
      return renderBox.localToGlobal(Offset(0, renderBox.size.height / 2));
    } else {
      RenderBox renderBox = _getTileRenderBox(0, toeWinData.column as int);
      return renderBox.localToGlobal(Offset(renderBox.size.width / 2, 0));
    }
  }

  ///
  ///
  /// Get end position of winning line
  ///
  Offset _getWinningLineEnd(TicTacToeWinData? winData) {
    TicTacToeWinData toeWinData = winData as TicTacToeWinData;
    if (toeWinData.winningMethod == "left-diagonal") {
      RenderBox renderBox = _getTileRenderBox(
          boardData.bottomRight.row, boardData.bottomRight.column);
      return renderBox
          .localToGlobal(Offset(renderBox.size.width, renderBox.size.height));
    }
    if (toeWinData.winningMethod == "right-diagonal") {
      RenderBox renderBox = _getTileRenderBox(
          boardData.bottomLeft.row, boardData.bottomLeft.column);
      return renderBox.localToGlobal(Offset(0, renderBox.size.height));
    }
    if (toeWinData.winningMethod == "row") {
      RenderBox renderBox = _getTileRenderBox(
          toeWinData.row as int, tiles[toeWinData.row as int].length - 1);
      return renderBox.localToGlobal(
          Offset(renderBox.size.width, renderBox.size.height / 2));
    } else {
      RenderBox renderBox =
          _getTileRenderBox(tiles.length - 1, toeWinData.column as int);
      return renderBox.localToGlobal(
          Offset(renderBox.size.width / 2, renderBox.size.height));
    }
  }

  Widget get _winningLine {
    return Positioned.fill(
        child: CustomPaint(
      painter: LinesPainter(
          _getWinningLineStart(winner), _getWinningLineEnd(winner)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: _board),
      if (winner != null && !(winner as TicTacToeWinData).draw) ...[
        _winningLine
      ]
    ]);
  }
}

///
/// Represents a simple square board tile
///
class BoardTile extends StatefulWidget {
  final int row;
  final int column;
  final Widget child;
  final bool touchEnabled;
  void Function(int row, int column)? onTapped;
  BoardTile(this.row, this.column, this.child,
      {this.touchEnabled = false, Key? key, this.onTapped})
      : super(key: key);
  _BoardTileState createState() => _BoardTileState();
}

class _BoardTileState extends State<BoardTile> {
  Widget? _content;
  bool _touchEnabled = false;

  @override
  void initState() {
    super.initState();
    _content = widget.child;
    _touchEnabled = widget.touchEnabled;
  }

  void setContent(Widget content) {
    setState(() {
      _content = content;
    });
  }

  void setTouchEnabled(bool touchEnabled) {
    _touchEnabled = touchEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _callOnTapped, child: _content);
  }

  void _callOnTapped() {
    if (_touchEnabled) widget.onTapped?.call(widget.row, widget.column);
  }
}

class LinesPainter extends CustomPainter {
  final Offset? start;
  final Offset? end;
  final double strokeWidth;
  final Color color;

  LinesPainter(this.start, this.end,
      {this.strokeWidth = 4, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;

    canvas.drawLine(
        start as Offset,
        end as Offset,
        Paint()
          ..strokeWidth = strokeWidth
          ..color = color);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
