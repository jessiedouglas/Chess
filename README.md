Chess
=====

A Ruby app played in the terminal.

#### Features

* Two-player (both human)

* Check validity of moves before you make them

* Doesn't allow players to move if move will put/leave them in check by checking all possible outcomes of move

Not currently supported: castling, en passant, pawn promotion

#### Running This App

1. `git clone` or download this repository

2. In the command line, `cd` into the folder you just downloaded

3. In the command line, run `ruby game.rb`

#### Playing in the Terminal

When asked for a move, type in your move in standard chess notation, with the current position of the piece followed by the 
desired position of the piece, separated by commas (i.e. "a2,c3")
