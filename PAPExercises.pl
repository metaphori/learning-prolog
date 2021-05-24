:- module(pap_exercises, [height/2, search_in_bstree/2, flatten_bstree/2, bstree_insert/3, bstree_check/1, bad/1]).

bad(1).

/* LISTS (INCLUDING STRINGS) */

% length/2 is true if N is the length of the list Xs
mylength([], 0) :- !.
mylength([_|Xs], N) :- mylength(Xs, N1), N is N1+1. 
% NOTA: se si fosse fatto:     N1 is N-1, mylength(Xs, N1)
%                  oppure:     N is N1+1, mylength(Xs, N1)
%     si avrebbe avuto un errore nel calcolo  ?- mylength([1,2,3], N)

% is_present/2 is true if X is in Xs
is_present([X|Xs], X) :- !. % cut 
is_present([X|Xs], Y) :- is_present(Xs, Y).

% last/2 is true if X is the last element of Xs
mylast([X|[]], X) :- !.
mylast([X|Xs], Y) :- mylast(Xs, Y).

%find the n-th element of a list (the first must be 1)
% nth(Xs,N,X)
% nth/3 is true if X is the Nth of the list Xs
mynth([X|_],  1, X).
mynth([X|Xs], N, Y) :- mynth(Xs, N1, Y), N is N1+1.

%- reverse a list  % rev(Xs,Ys)
% rev/2 is true if Ys is the reverse list of Xs
rev([], []) :- !.
rev([X|Xs], Ys) :- mylast(Ys,X), append(Ys2, [X], Ys), rev(Xs, Ys2).

% is_palindrome/1 is true if Xs is palindrome
is_palindrome(Xs) :- rev(Xs,Xs).

% insert_at - Insert an element at a given position into a list.
insert_at([],     E, _,   [E]).
insert_at([X|Xs], E, 0,   [E,X|Xs]). % una volta inserito E, il resto della lista d'ingresso è da aggiungere al risultato
insert_at([X|Xs], E, 1,   [X,E|Xs]). 
insert_at([X|Xs], E, Pos, Res) :- NewPos is Pos-1, insert_at(Xs, E, NewPos, NewRes), Res = [X|NewRes].
                                         % NB: come il risultato è costruito --------^^^
% merge l1 l2 -  compute the ordered list computed by merging the two ordered lists l1 and l2
merge(Xs, [], Xs).
merge([], Ys, Ys).
merge([X|Xs], [Y|Ys], Res) :- X<Y, merge(Xs, [Y|Ys], SubRes), Res = [X|SubRes].
merge([X|Xs], [Y|Ys], Res) :- X>=Y, merge([X|Xs], Ys, SubRes), Res = [Y|SubRes].
  % Note however that invertibility does not work with this impl 
  % ?- merge(X, [1,10], [0,1,5,10]).  =====> uncaught exception: error(instantiation_error,(<)/2)

%  pack - eliminate consecutive duplicates of list elements.
pack([], []).
pack([X,X|Xs],  Ys) :- pack([X|Xs], Ys), !. % necessario il cut per evitare che pack([1,1,2], [1,1,2]) dia True
pack([X|Xs],    Ys) :- pack(Xs, SubRes), Ys = [X|SubRes].   

% pack_sub - pack consecutive duplicates of list elements into sublists. If a list contains repeated elements they should be placed in separate sublists.
pack_sub([], []).
pack_sub(Xs, Res) :- pack_sub2(Xs, [], Res).
pack_sub2([],         Partial, Partial).
pack_sub2([X,X|Xs],   Partial, Ys) :- pack_sub2([X|Xs], Partial2, Ys), Partial2=[X|Partial].
pack_sub2([X|Xs],     Partial, Ys)   :- pack_sub2(Xs, [], Ys2), Ys = [[X|Partial]|Ys2].

% - tokenizer - split a string at whitespace
tokenize(Str, SplittedStr) :- tokens(Str, [], SplittedStr).
tokens([],      S, [S]).
tokens([X|Xs],  S, Res) :- char_code(' ', X), tokens(Xs, [], NewRes), Res=[S|NewRes].
tokens([X|Xs],  S, Res) :- append(S,[X],NewPartial), tokens(Xs, NewPartial, Res).







% encode - compute the run-length encoding of a list. Consecutive duplicates of elements are encoded as lists (N E) where N is the number of duplicates of the element E.
encode([], []).
encode(Xs, Ys) :- encode2(Xs, 1, Ys).
encode2([], _, []).
encode2([X,X|Xs], N, Ys) :- N1 is N+1, encode2([X|Xs], N1, Ys), !.
encode2([X|Xs],   N, Ys) :- encode2(Xs, 1, SubRes), Ys= [[N, X] | SubRes].

% decode - Decode a run-length encoded list. Given a run-length code list generated as specified previously. Construct its uncompressed version.
decode([], []).
decode([[N,X]|Xs], Ys) :- repeat_elem(X,N,PartialRes), decode(Xs, NewRes), append(PartialRes, NewRes, Ys).
repeat_elem(E, 1, [E]) :- !.
repeat_elem(E, N, Res) :- N1 is N-1, repeat_elem(E, N1, SubRes), Res=[E|SubRes].

% duplicate - Duplicate the elements of a list. duplicate([1,2,3], [1,1,2,2,3,3])
duplicate([], []).
duplicate([X|Xs], [X,X|Ys]) :- duplicate(Xs,Ys).

% replicate - replicate - Replicate the elements of a list a given number of times.
replicate([], _, []).
replicate([X|Xs], N, Ys) :- repeat_elem(X, N, SubRes1), replicate(Xs, N, SubRes2), append(SubRes1, SubRes2, Ys). 

% drop_nth - Drop every N'th element from a list.
drop_nth([], _, []).
drop_nth(Xs, N, Res) :- drop(Xs, 1, N, Res).
drop([], _, _, []).
drop([X|Xs], N, N, Ys) :- drop(Xs, 1, N, Ys).
drop([X|Xs], C, N, Ys) :- C1 is C+1, drop(Xs, C1, N, SubRes), Ys = [X|SubRes].

% rotate - Rotate a list N places to the left.
rotate([], _, []).
rotate(Xs, 0, Xs).
rotate([X|[]], _, [X]).
rotate([X1|Xs], 1, Ys) :- append(Xs,[X1],Ys).  % [1,2,3,4] N=1   ===>   [2,3,4,1] cioè [2,3,4] va in testa e [1] in coda
rotate(Xs, N, Ys) :- rotate(Xs, 1, Xs2), N1 is N-1, rotate(Xs2, N1, Ys). % Rotazione di N => N volte la rotazione di 1

% extract - Extract a slice from a list. Given two indices, i and k, the slice is the list containing the elements between the i'th and k'th element of the original list (both limits included). Start counting the elements with 1
extract([], _, _, []).
extract(_, _, 0, []).
extract([X|Xs], 1, End, Res) :- Res=[X|RestRes], E1 is End-1, extract(Xs, 1, E1, RestRes). % tiene gli elementi finché End=0
extract([X|Xs], Start, End, Res) :- End>=Start, Start>0, S1 is Start-1, E1 is End-1, extract(Xs, S1, E1, Res). % scorre la lista fino a che Start=0

/* BINARY TREES : Define a possible representation binary trees & Define then the following predicates */
/* * Representation, example ==> btree( VALUE, btree(VALUE, void, btree(VALUE, void, 5)), void )  ... 
 ossia  BTREE = btree(VALUE, BTREE_left, BTREE_right) | void */
%- height - a function that yields the maximum height of a binary tree
% Altezza h di un albero binario == max profondità raggiunta dalle sue foglie, cio la max distanza di una foglia dalla radice in termini di num archi percorsi.
node_left(Btree, Left) :- Btree = btree( _, Left, _ ).
node_right(Btree, Right) :- Btree = btree( _, _, Right).

height(btree(_,void,void), 0).
height(btree(_,Left,Right), H) :- height(Left, ML), height(Right, MR), max(ML, MR, Max), H is 1+Max.
height(void, 0).

max(A,B,A) :- A>B.
max(A,B,B).



%- countLeaves - counts the leaves of a binary tree
countLeaves(void, 0).
countLeaves(btree(_,void,void), 1).
countLeaves(btree(_,Left,Right), N) :- countLeaves(Left,N1), countLeaves(Right,N2), N is N1+N2.

%- isSymmetric - Let us call a binary tree symmetric if you can draw a vertical line through the root node and then the right subtree is the mirror image of the left subtree.
flip(btree(_,void,void), btree(_,void,void)).
flip(btree(_,Left,void), btree(_,void,Left2)) :- flip(Left,Left2).
flip(btree(_,void,Right), btree(_,Right2,void)) :- flip(Right,Right2).
flip(btree(_,Left,Right), R) :- flip(Right,R2), flip(Left,L2), R = btree(_, L2, R2).

isSymmetric(btree(_,void,void)).
isSymmetric(btree(_,Left,Right)) :- flip(Left,Right). % se il flip della parte sinistra fa ottenere il ramo di destra


/*BINARY SEARCH TREES (i.e. ORDERED BINARY TREES) Define the binary search tree data structure. Then define the following predicates:*/
%- search - determine if an element is in the tree
search_in_bstree(bstree(X,_,_), X) :- !.
search_in_bstree(bstree(X,_,Right), Y) :- Y>X, search_in_bstree(Right, Y).
search_in_bstree(bstree(X,Left,_), Y) :- Y<X, search_in_bstree(Left, Y).

%- flatten - returns a list with all sorted elements of the tree
flatten_bstree(void, []).
flatten_bstree(bstree(X,Left,Right), Xs) :- flatten_bstree(Left, Minors), flatten_bstree(Right, Majors), append(Minors, [X|Majors], Xs).

%- insert - computes a new tree including a new element
bstree_insert(bstree(X,void,_), Y, Res) :- Y<X, Res = bstree(X,bstree(Y,void,void),_).
bstree_insert(bstree(X,_,void), Y, Res) :- Y>X, Res = bstree(X,_,bstree(Y,void,void)).
bstree_insert(bstree(X,L,_), Y, Res)    :- Y<X, bstree_insert(L,Y,SubRes), Res = bstree(X, SubRes, _).
bstree_insert(bstree(X,_,R), Y, Res)    :- Y>X, bstree_insert(R,Y,SubRes), Res = bstree(X, _, SubRes).

%- is_a_bstree - check if the argument is really a BSTRee
bstree_check(bstree(_,void,void)).
bstree_check(bstree(X,void,R)) :- R=bstree(Y,YL,YR), Y>X, bstree_check(R).
bstree_check(bstree(X,L,void)) :- L=bstree(Y,YL,YR), Y<X, bstree_check(L).
bstree_check(bstree(X,L,R))    :- bstree_check(bstree(X,L,void)), bstree_check(bstree(X,void,R)).


