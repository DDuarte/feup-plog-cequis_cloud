even(N) :- N mod 2 =:= 0.
odd(N) :- \+ even(N).

valid_move(Line, Column, LineTo, Column) :-
	LineTo = Line + 1.

valid_move(Line, Column, LineTo, Column) :-
	LineTo = Line - 1.
	
valid_move(Line, Column, Line, ColumnTo) :-
	ColumnTo = Column + 1.
	
valid_move(Line, Column, Line, ColumnTo) :-
	ColumnTo = Column - 1.	

%% Even Columns %%

valid_move(Line, Column, LineTo, ColumnTo) :-
	even(Column),
	LineTo = Line + 1,
	ColumnTo = Column + 1.

valid_move(Line, Column, LineTo, ColumnTo) :-
	even(Column),
	LineTo = Line + 1,
	ColumnTo = Column - 1.

%%				%%

valid_move(Line, Column, LineTo, ColumnTo) :-
	odd(Column),
	LineTo = Line - 1,
	ColumnTo = Column + 1.
	
valid_move(Line, Column, LineTo, ColumnTo) :-
	odd(Column),
	LineTo = Line - 1,
	ColumnTo = Column - 1.

%% Odd Columns %%

.


%%			   %%