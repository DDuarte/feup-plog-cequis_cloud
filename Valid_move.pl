even(N) :- N mod 2 =:= 0.
odd(N) :- \+ even(N).

valid_move(Line, Column, LineTo, Column) :-
	LineTo is Line + 1.

valid_move(Line, Column, LineTo, Column) :-
	LineTo is Line - 1.
	
valid_move(Line, Column, Line, ColumnTo) :-
	ColumnTo = Column + 1.
	
valid_move(Line, Column, Line, ColumnTo) :-
	ColumnTo is Column - 1.	

%% Even Columns %%

valid_move(Line, Column, LineTo, ColumnTo) :-
	even(Column),
	LineTo is Line + 1,
	ColumnTo is Column + 1.

valid_move(Line, Column, LineTo, ColumnTo) :-
	even(Column),
	LineTo is Line + 1,
	ColumnTo is Column - 1.

%%				%%

%% Odd Columns %%

valid_move(Line, Column, LineTo, ColumnTo) :-
	odd(Column),
	LineTo is Line - 1,
	ColumnTo is Column + 1.
	
valid_move(Line, Column, LineTo, ColumnTo) :-
	odd(Column),
	LineTo is Line - 1,
	ColumnTo is Column - 1.

%%			   %%