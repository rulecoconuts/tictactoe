abstract class BoardData {
  List<List> get rep;
}

///
/// A simple class to represent row and column
///
class BoardPosition{
  final int row;
  final int column;
  BoardPosition(this.row, this.column);
}

class TicTacToeWinData {
  dynamic winner;
  int? row = 0;
  int? column = 0;
  String winningMethod = "row";
  bool draw;

  TicTacToeWinData(this.winner, this.row, this.column, this.winningMethod, {this.draw=false});
  factory TicTacToeWinData.draw(){
    return TicTacToeWinData(null, null, null, "none", draw: true);
  }
}

class TicTacToeBoardData extends BoardData {
  List<List> _rep = [];

  @override
  List<List> get rep => _rep;

  int numberOfMoves = 0;

  ///
  /// Creates a [size] by [size] TicTacToeBoard Representation
  ///
  TicTacToeBoardData(int size) {
    _rep = List.generate(
        size, (row) => List.generate(size, (column) => null, growable: false),
        growable: false);
  }

  ///
  /// Returns the winning data if the content of a row is the same else returns null
  ///
  TicTacToeWinData? rowUniform(int row) {
    if (rep[row].every((element) => rep[row].first == element)) {
      return TicTacToeWinData(rep[row].first, row, null, "row");
    }
    return null;
  }

  ///
  /// Returns the winning data if the content of a column is the same else returns null
  ///
  TicTacToeWinData? columnUniform(int column) {
    if (rep.every((row) => row[column] == rep.first[column])) {
      return TicTacToeWinData(rep.first[column], null, column, "column");
    }

    return null;
  }

  ///
  /// Returns the winning data if either diagonal of the board is uniform else returns null
  ///
  TicTacToeWinData? get diagonalUniform {
    dynamic winningData = leftDiagonalUniform;
    if (winningData != null) return winningData;
    return rightDiagonalUniform;
  }

  ///
  /// Returns the winning data if the left diagonal of the board is uniform else returns null
  ///
  TicTacToeWinData? get leftDiagonalUniform {
    dynamic firstCharacter = rep[0][0];
    for (int row = 0; row < rep.length; row++) {
      int column = row;

      if (rep[row][column] != firstCharacter) return null;
    }
    return TicTacToeWinData(firstCharacter, null, null, "left-diagonal");
  }

  ///
  /// Returns the winning data if the right diagonal of the board is uniform else returns null
  ///
  TicTacToeWinData? get rightDiagonalUniform {
    dynamic firstCharacter = rep[0].last;
    for (int row = 0; row < rep.length; row++) {
      int column = rep.length - 1 - row;

      if (rep[row][column] != firstCharacter) return null;
    }
    return TicTacToeWinData(firstCharacter, null, null, "right-diagonal");
  }

  ///
  /// Returns true if the coordinates are on a diagonal of the board
  ///
  bool isOnDiagonal(int row, int column) {
    return isOnLeftDiagonal(row, column) || isOnRightDiagonal(row, column);
  }

  bool isOnLeftDiagonal(int row, int column) {
    return row == column;
  }

  bool isOnRightDiagonal(int row, int column) {
    return (row + column == rep.length - 1);
  }

  ///
  /// Returns the row and column of the top left tile as a [BoardPosition].
  ///
  BoardPosition get topLeft{
    return BoardPosition(0, 0);
  }

  ///
  /// Returns the row and column of the top right tile as a [BoardPosition].
  ///
  BoardPosition get  topRight{
    return BoardPosition(0, rep.length-1);
  }

  ///
  /// Returns the row and column of the bottom right tile as a [BoardPosition].
  ///
  BoardPosition get bottomRight{
    return BoardPosition(rep.length-1, rep.length-1);
  }

  ///
  /// Returns the row and column of the bottom left tile as a [BoardPosition].
  ///
  BoardPosition get bottomLeft{
    return BoardPosition(rep.length-1, 0);
  }

  ///
  /// Insert an element into the board
  ///
  TicTacToeWinData? insert(int row, int column, dynamic element) {
    rep[row][column] = element;
    numberOfMoves++;
    if(isDraw()) return TicTacToeWinData.draw();
    return getWinner(row, column);
  }

  bool isDraw(){
    return numberOfMoves == rep.length * rep.first.length;
  }

  ///
  /// Returns winner element if a winner exists else return false
  ///
  TicTacToeWinData? getWinner(int row, int column) {
    TicTacToeWinData? winner = rowUniform(row);
    if (winner != null) return winner;

    winner = columnUniform(column);
    if (winner != null) return winner;

    if (isOnLeftDiagonal(row, column)) {
      winner = leftDiagonalUniform;
      if (winner != null) return winner;
    }

    if (isOnRightDiagonal(row, column)) {
      winner = rightDiagonalUniform;
      if (winner != null) return winner;
    }
  }
}
