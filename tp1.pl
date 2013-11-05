%%  Prolog implementation of Cequis - Sumo   %%
%%        FEUP - MIEIC - 2013/2014           %%
%%                                           %%
%% Authors:                                  %%
%% + Duarte Duarte - ei11101@fe.up.pt        %%
%% + Hugo Freixo   - ei11086@fe.up.pt        %%
%%                                           %%
%%      a   b   c   d   e   f   g            %%
%%     ___     ___     ___     ___           %%
%% 8  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/   \___/   \___/          %%
%% 7  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/   \___/   \___/          %%
%% 6  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/ w \___/   \___/          %%
%% 5  /   \___/ w \___/ w \___/   \          %%
%%    \___/   \___/ o \___/   \___/          %%
%% 4  /   \___/ b \___/ b \___/   \          %%
%%    \___/   \___/ b \___/   \___/          %%
%% 3  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/   \___/   \___/          %%
%% 2  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/   \___/   \___/          %%
%% 1  /   \___/   \___/   \___/   \          %%
%%    \___/   \___/   \___/   \___/          %%
%%                                           %%
%% [[e,    e,    e,    e],                   %%
%%  [e, e, e, e, e, e, e],                   %%
%%  [e, e, e, e, e, e, e],                   %%
%%  [e, e, w, w, w, e, e],                   %%
%%  [e, e, b, o, b, e, e],                   %%
%%  [e, e, e, b, e, e, e],                   %%
%%  [e, e, e, e, e, e, e],                   %%
%%  [e, e, e, e, e, e, e]]                   %%
%%                                           %%
%%  b - black (P1 pieces)                    %%
%%  w - white (P2 pieces)                    %%
%%  e - empty (nothing)                      %%
%%  o - objective (objective piece)          %%
%%                                           %%
%% http://www.cequis.ca/variations/Sumo.php  %%
%%                                           %%

library(lists).
% use_module(library(lists)).

empty_piece(e).
p1_piece(w).
p2_piece(b).
obj_piece(o).

%% board creation - main method is create_board(N, B) - N has to be even %%

create_board(N, B) :-
    length(B, N),
    create_board_aux(N, 0, B),
    init_board(N, B).

init_board(N, B) :-
    obj_piece(ObjPiece),
    p1_piece(P1Piece),
    p2_piece(P2Piece),
    empty_piece(Piece),
    No2m2 is N // 2 - 2,
    No2m1 is N // 2 - 1,
    No2 is N // 2,
    No2p1 is N // 2 + 1,
    nth0(No2, B, MidRow), nth0(No2m1, MidRow, ObjPiece),
                          nth0(No2, MidRow, P2Piece),
                          nth0(No2m2, MidRow, P2Piece),
    nth0(No2p1, B, MidRowp1), nth0(No2m1, MidRowp1, P2Piece),
    nth0(No2m1, B, MidRowm1), nth0(No2, MidRowm1, P1Piece),
                              nth0(No2m1, MidRowm1, P1Piece),
                              nth0(No2m2, MidRowm1, P1Piece),
    init_row(B, Piece).

create_board_aux(N, N, _).
create_board_aux(N, NL, B) :-
    create_row(N, NL, Row),
    nth0(NL, B, Row),
    NL1 is NL + 1,
    create_board_aux(N, NL1, B).

create_row(N, 0, Row) :-
    !, No2 is N // 2,
    length(Row, No2).
create_row(N, _, Row) :-
    Nm1 is N - 1,
    length(Row, Nm1).

init_row([], _).
init_row([B|BT], Piece) :-
    init_row_aux(B, Piece),
    init_row(BT, Piece).

init_row_aux([], _).
init_row_aux([H|HT], Piece) :-
        nonvar(H),
        init_row_aux(HT, Piece).
init_row_aux([Piece|HT], Piece) :-
    init_row_aux(HT, Piece).

%% board representation - main method is show_board(B) %%

show_board(B) :-
    length(B, N),
    Nm1 is N - 1,
    No2 is N // 2,
    write('    '), draw_letters(Nm1), nl,
    write('  '), draw_slashes(No2), nl,
    show_line(B, 0),
    write('  '), draw_lower_cell(No2), nl, !.

draw_piece(x) :- write('err').
draw_piece(b) :- write(' b ').
draw_piece(w) :- write(' w ').
draw_piece(o) :- write(' o ').
draw_piece(e) :- write('   ').
draw_piece(N) :- write(' '), write(N), write(' ').

letters([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]).

draw_letters(N) :-
    letters(L),
    sublist(L, SL, 0, N, _),
    draw_letters_aux(SL).

draw_letters_aux([]).
draw_letters_aux([H|T]) :-
    write(' '), write(H), write('  '),
    draw_letters_aux(T).

draw_line_number(N) :-
    N >= 0,
    N < 10,
    write(N), write('  ').
draw_line_number(N) :-
    N >= 10,
    N < 100,
    write(N), write(' ').
draw_line_number(N) :-
    N >= 100,
    N < 1000,
    write(N).

draw_slashes(0).
draw_slashes(N) :-
    write('  ___   '),
    N1 is N - 1,
    draw_slashes(N1).

draw_lower_cell(0).
draw_lower_cell(N) :-
    write(' \\___/  '),
    N1 is N - 1,
    draw_lower_cell(N1).

show_line([], _).
show_line([BH|BT], LINEN) :-
    even(LINEN),
    LINEN1 is LINEN + 1,
    length([BH|BT], X),
    draw_line_number(X),
    show_piece(BH, LINEN, 0), nl,
    show_line(BT, LINEN1).
show_line([BH|BT], LINEN) :-
    odd(LINEN),
    LINEN1 is LINEN + 1,
    write('   '),
    show_piece(BH, LINEN, 0), nl,
    show_line([BH|BT], LINEN1).

show_piece([], _, _).
show_piece(L, 0, PIECEN) :-
    odd(PIECEN),
    write('___'),
    PIECEN1 is PIECEN + 1,
    show_piece(L, 0, PIECEN1).
show_piece([LH|LT], LINEN, PIECEN) :-
    even(LINEN),
    even(PIECEN),
    write('/'), draw_piece(LH), write('\\'),
    PIECEN1 is PIECEN + 1,
    show_piece(LT, LINEN, PIECEN1).
show_piece([_|LT], LINEN, PIECEN) :-
    even(LINEN),
    odd(PIECEN),
    write('___'),
    PIECEN1 is PIECEN + 1,
    show_piece(LT, LINEN, PIECEN1).
show_piece([_|LT], LINEN, PIECEN) :-
    odd(LINEN),
    even(PIECEN),
    write('\\___/'),
    PIECEN1 is PIECEN + 1,
    show_piece(LT, LINEN, PIECEN1).
show_piece([LH|LT], LINEN, PIECEN) :-
    odd(LINEN),
    odd(PIECEN),
    draw_piece(LH),
    PIECEN1 is PIECEN + 1,
    show_piece(LT, LINEN, PIECEN1).

%% game beginning and ending - main method is play(Game) %%

play(Game) :-
    create_board(Game),
    show_board(Game),
    player(P),
    play(Game, P, Result).

game_over([], Player, Result) :-
    Result = Player.
game_over([Line|Lines], Player, _) :-
    obj_piece(ObjPiece),
    member(ObjPiece, Line), !, fail.
game_over([Line|Lines], Player, Result) :-
    game_over(Lines, Player, Result).

announce(Result) :-
    write('Game over, '),
    write(Result),
    write(' won!'), nl.

play(Game, Player, Result) :-
    game_over(Game, Player, Result), !, announce(Result).
play(Game, Player, Result) :-
    choose_move(Game, Player, Move),
    move(Game, Move, Position),
    display_game(Position1, Player),
    next_player(Player, Player1),
    !, play(Position1, Player1, Result).

%% choose_move(Position, computer, Move) :-
%%     findall(M, move(Position, M), Moves),
%%     evaluate_and_choose(Moves, Position, (nil, -1000), Move).
%% 
%% evaluate_and_choose([Move|Moves], Position, Record, BestMove) :-
%%     move(Move, Position, Position1),
%%     value(Position1, Value),
%%     update(Move, Value, Record, Record1),
%%     evaluate_and_choose(Moves, Position, Record1, BestMove).
%% evaluate_and_choose([], Position, (Move, Value), Move).
%% 
%% update(Move, Value, (Move1, Value1), (Move1, Value1)) :-
%%     Value =< Value1.
%% update(Move, Value, (Move1, Value1), (Move, Value)) :-
%%     Value > Value1.

%% helpers %%

even(N) :- N mod 2 =:= 0.
odd(N) :- \+ even(N).

%% show_board([[e, e, e, e], [e, e, e, e, e, e, e], [e, e, e, e, e, e, e], [e, e, w, w, w, e, e], [e, e, b, o, b, e, e], [e, e, e, b, e, e, e], [e, e, e, e, e, e, e], [e, e, e, e, e, e, e]]).
