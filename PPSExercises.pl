% search(Elem,List)
search(X,[X|_]).
search(X,[_|Xs]) :- search(X,Xs).
% QUERY: search(4, [3,8,1,4,7]).
% ITERATION: search(X, [a,b,c]).
% GENERATION: search(a, X). search(a, [b,X,c,Y,d]). search(X,Xs).

% search2(Elem,List) 
% looks for two consecutive occurrences of Elem
search2(X,[X,X|_]). 
search2(X,[_|Xs]):-search2(X,Xs).
% search2(a,[_,_,a,_,_]).

search_two(X, [X,_,X|_]).
search_two(X, [_|Xs]) :- search_two(X,Xs).

% search_two(Elem,List)
% looks for two occurrences of Elem with an element in between!
sb(E,[E,_,E|_]).
sb(E,[_|Xs]) :- sb(E,Xs).
% sb(X,[P1,b,a,c,d,P4]).
% yes. X / a  P1 / a Solution: sb(a,[a,b,a,c,d,P4])
% yes. X / c  P4 / c Solution: sb(c,[P1,b,a,c,d,c])
% no.

% search_anytwo(Elem,List)
% looks for any Elem that occurs two times
sa(E,[E|Xs]) :- member(E,Xs). % also: search(E,Xs)
sa(E,[_|Xs]) :- sa(E,Xs).

% size(List,Size)
% Size will contain the number of elements in List
size([],0).
size([_|T],M) :- size(T,N), M is N+1.
% Can it allow for a fully relational behaviour?
% Yep. E.g., size([a,b|X],K).
% yes. X / []  K / 2 Solution: size([a,b],2)
% yes. X / [_68281]  K / 3 Solution: size([a,b,_68281],3)
% yes. X / [_68291,_68293]  K / 4 Solution: size([a,b,_68291,_68293],4)

% all_bigger(List1,List2)
% all elements in List1 are bigger than those in List2, 1 by 1
% example: all_bigger([10,20,30,40],[9,19,29,39]).
all_bigger([],Ys).
all_bigger([X|Xs],Ys) :- bigger(X,Ys), all_bigger(Xs,Ys).
bigger(E,[]).
bigger(E,[X|Xs]) :- E>X, bigger(E,Xs).
% all_bigger([4,7,5],[1,2,3]). YES
% all_bigger([4,7,X],[1,2,3]). HALT
% all_bigger([4,7,5],[1,2,X]). HALT

% sublist(List1,List2)
% List1 should be a subset of List2
% example: sublist([1,2],[5,3,2,1]).
sublist([],Ys) :- list(Ys).
sublist([X|Xs],Ys) :- search(X,Ys), sublist(Xs,Ys).

% seq(N,List)
% example: seq(5,[0,0,0,0,0]).
seq(0,[]).
seq(N,[0|T]):- N > 0, N2 is N-1, seq(N2,T).
% QUESTION: is it fully relational?
% NO, as seq(K,[0,0,0]). HALT

% seqR(N,List)
% example: seqR(4,[4,3,2,1,0]).
seqR(0,[0]).
seqR(N,[N|Xs]) :- N>0, N1 is N-1, seqR(N1,Xs).

% seqR2(N,List)
% example: seqR2(4,[0,1,2,3,4]).
seqR2(0,[0]).
seqR2(N,Xs) :- N>0, N1 is N-1, seqR2(N1,Ys), last(Ys,N,Xs).
% seqR2(4,Xs). yes. Xs / [0,1,2,3,4] Solution: seqR2(4,[0,1,2,3,4])
% seqR2(K,[0,1,2,3,4]). HALT

last([],N,[N]).
last([H|T],N,L2) :- append([H|T],[N],L2).

% double(List,List)
% suggestion: remember predicate append/3
% example: double([1,2,3],[1,2,3,1,2,3]).
double(L,R) :- append(L,L,R).

% times(List,N,List)
% example: times([1,2,3],3,[1,2,3,1,2,3,1,2,3]).
times(L,0,[]).
times(L,N,Res) :- N>0, N1 is N-1, times(L,N1,Pres), append(Pres,L,Res).

% inv(List,List)
% example: inv([1,2,3],[3,2,1]).
inv([],[]).
inv([H|T], L) :- inv(T,L2), last(L2,H,L).

% proj(List,List)
% example: proj([[1,2],[3,4],[5,6]],[1,3,5]).
proj([],[]).
proj([[H|_]|Ls],[H|R]) :- proj(Ls,R).

% dropAny(?Elem,?List,?OutList)
dropAny(X,[X|T],T).
dropAny(X,[H|Xs],[H|L]):-dropAny(X,Xs,L).

% Try to realise some of the following variations, by using cut and/or reworking the implementation
% - dropFirst: drops only the first occurrence (showing no alternative results)
% - dropLast: drops only the last occurrence (showing no alternative results)
% - dropAll: drop all occurrences, returning a single list as result


dropFirst(X, [X|T], T).
dropFirst(X, [Y|T], [Y|R]) :- dropFirst(X,T,R), !.
% dropFirst(X,[3,4,2,3,6],L).
%  - yes. X / 3  L / [4,2,3,6] Solution: dropFirst(3,[3,4,2,3,6],[4,2,3,6])
%  - yes. X / 4  L / [3,2,3,6] Solution: dropFirst(4,[3,4,2,3,6],[3,2,3,6])
% dropFirst(3,[3,4,2,3,6],L).
%  - yes. L / [4,2,3,6] Solution: dropFirst(3,[3,4,2,3,6],[4,2,3,6])
%  - yes. L / [3,4,2,6] Solution: dropFirst(3,[3,4,2,3,6],[3,4,2,6])
% NOT CORRECT (second example, only first drop must be given)

dropFirst2(X, [X|T], T).
dropFirst2(X, [Y|T], [Y|R]) :- dropFirst2(X,T,R).
% dropFirst2(X,[3,4,2,3,6],L).
%  - yes. X / 3  L / [4,2,3,6] Solution: dropFirst2(3,[3,4,2,3,6],[4,2,3,6])
% dropFirst2(3,[3,4,2,3,6],L).
%  - yes. L / [4,2,3,6] Solution: dropFirst2(3,[3,4,2,3,6],[4,2,3,6])
% CORRECT BUT DOESN'T PROVIDE ALL "first drops" (see example 1)

dropFirst3(X,[],[]) :- !.
dropFirst3(X, [X|T], T).
dropFirst3(X, [Y|T], [Y|R]) :- dropFirst3(X,T,R).
% dropFirst3(X,[3,4,2,3,6],L).
%  - yes. X / 3  L / [4,2,3,6]   Solution: dropFirst3(3,[3,4,2,3,6],[4,2,3,6])
%  - yes. X / 4  L / [3,2,3,6]   Solution: dropFirst3(4,[3,4,2,3,6],[3,2,3,6])
%  - yes. X / 2  L / [3,4,3,6]   Solution: dropFirst3(2,[3,4,2,3,6],[3,4,3,6])
%  - yes. X / 3  L / [3,4,2,6]   Solution: dropFirst3(3,[3,4,2,3,6],[3,4,2,6])
%  - yes. X / 6  L / [3,4,2,3]   Solution: dropFirst3(6,[3,4,2,3,6],[3,4,2,3])
%  - yes.        L / [3,4,2,3,6] Solution: dropFirst3(X,[3,4,2,3,6],[3,4,2,3,6])

% IDEA: keep track of elements already removed first
dropFirst4(X,[],_,[]) :- !.
dropFirst4(X, [X|T], _, T).
dropFirst4(X, [X|T], [X|R], T) :- not(member(X,R)).
dropFirst4(X, [Y|T], R, [Y|U]) :- X\=Y, dropFirst4(X,T,R,U).

% dropLast

% dropLast(X,L,R): drops only the last occurrence (showing no alternative results)
% dropAll(X,L,R): drop all occurrences, returning a single list as result
dropAll(X,[],[]).
dropAll(X,[Y|L],R) :- copy_term(X,Y), !, dropAll(X,L,R). %%%%%%%%%%%% !!!!!!!!!!!!!!!!!!!!!!!!!! NOTE: copy_term
dropAll(X,[Y|L],[Y|R]) :- X\=Y, dropAll(X,L,R).
% dropAll(1,[1,2,1,6,3,1], L). => yes. L / [2,6,3] Solution: dropAll(1,[1,2,1,6,3,1],[2,6,3])

all(_,[]).
all(X,[Y|T]):-copy_term(X,Y),all(X,T).
% copy_term(X,Y):
%– clones term X and unifies the result with Y
%– it is basically a unification check that do not affect the first argument, but only second
% motivation
% all(_,[]).
% all(X,[X|T]):-all(X,T).
% ?-all(p(X),[p(1),p(1),p(1)]). -> Yes
% ?-all(p(X),[p(1),p(1),p(2)]). -> No!!!! What happened?

% fromList(+List,-Graph) :- yields a graph from a list 
% (e.g., from [A,B,C], it gets  A -> B -> C, represented as [e(A,B),e(B,C))
fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).

% fromCircList(+List,-Graph) :- like fromList but also links the last and the first element
fromCircList([H|T],G) :- fromList([H|T],G2), last([H|T],L), append(G2,[e(L,H)],G).
% fromCircList([10,20,30],[e(10,20),e(20,30),e(30,10)]). YES
% fromCircList([10,20],[e(10,20),e(20,10)]). YES
% fromCircList([10],[e(10,10)]).

last([H],H).
last([_|T],L) :- last(T,L).

% dropNode(+Graph, +Node, -OutGraph)
% drop all edges starting and leaving from a Node (use dropAll defined in 1.1)
dropNode0(G,N,O):- dropAll(e(N,_),G,O). %, dropAll(e(_,N),G2,O).
% dropNode0([e(1,2),e(1,3),e(2,3)],1,L). 
%   => yes. L / [e(1,3),e(2,3)] Solution: dropNode0([e(1,2),e(1,3),e(2,3)],1,[e(1,3),e(2,3)])

dropNode(G,N,O) :- dropAll(e(N,X),G,G2), dropAll(e(Y,N),G2,O).
% NOTE: dropAll must use copyTerm

drop_reps(L,LL) :- setOf(X,member(X,L), LL), !.
% Sintatticamente mettere ! lì è per evitare che il predicato a sx dia più soluzioni

p.
once2(X) :- X, !. % NB: you can treat a term like a goal!!!
% Note: once(X) exists already in stdlib
%  once(member(E,[10,20,30])) => YES E/10

twice(X) :- X.
twice(X) :- X.

% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node possibly use findall, looking for e(Node,_) combined with member(?Elem,?List)
% - reaching([e(1,2),e(1,3),e(2,3)],1,L). -> L/[2,3]
% - reaching([e(1,2),e(1,2),e(2,3)],1,L). -> L/[2,2]).
reaching(G, X, N) :- findall(N, member(e(X,N), G), N).

% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2 if there are many path, they are showed 1-by-1
% anypath([e(1,2),e(1,3),e(2,3)],1,3,L).
%  => L/[e(1,2),e(2,3)]
%  => L/[e(1,3)]
anypath(G,N1,N2,P) :- !. % TODO
