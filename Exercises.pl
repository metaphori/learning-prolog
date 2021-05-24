
bt_height(  bt(Node,nil,nil), 0, [Node]).
bt_height(  bt(Node,L, nil),  N, [Node|P]) :- bt_height(L, N1, P), N is N1+1.
bt_height(  bt(Node,nil, R),  N, [Node|P]) :- bt_height(R, N1, P), N is N1+1.
bt_height(  bt(Node,L,R), N, [Node|Pmax] ) :- bt_height(L, NL, PL), bt_height(R, NR, PR), max(NL, PL, NR, PR, Nmax, Pmax), N is Nmax+1.

max( A1, A2, B1,  _, A1, A2) :- A1 >= B1, !.
max(  _,  _, B1, B2, B1, B2).

occs( [], _, []).
occs( [X|Xs], N, [X|Others] ) :- count(X, [X|Xs], N), remove_all(X, Xs, Xs2), occs(Xs2, N, Others).
occs( [X|Xs], N, Others) :- remove_all(X, Xs, Xs2), occs(Xs2, N, Others).

count(_, [], 0).
count(X, [X|Xs], N) :- count(X,Xs,N1), N is N1+1.
count(X, [Y|Ys], N) :- X\=Y, count(X,Ys,N).

remove_all(E, [], []).
remove_all(E, [E|Xs], Ys) :- remove_all(E, Xs, Ys), !.
remove_all(E, [X|Xs], [X|Ys]) :- remove_all(E, Xs, Ys).
