% Exercises TODO:
/*GRAPHS: A graph is defined as a set of nodes and a set of edges, where each edge is a pair of nodes. */
%- define the Graph data type ===>  graph([node(10),node(5),node(7)], [edge(10,5), edge(5,7])
%- path_available - given two nodes a and b, the predicate determines if there exists a path between a and b

path_available( graph(_, [edge(From,To)|_]), node(From), node(To) ).
path_available( graph(_, [edge(From,Next)|Edges]), node(From), node(To)) :- path_available( graph(_, Edges), node(Next), node(To) ).
path_available( graph(_, [E|Edges]), node(From), node(To)) :- append(Edges, [E], NewEdges), path_available( graph(_, NewEdges), node(From), node(To) ).
% need to be finished --- a way must be found to get all list elements and test each
% loops if no path is available
/*
path_available(graph(Nodes,Edges), Start, End) :- path_available_by_edges(Edges, Edges, [], Start,End).
path_available_by_edges([edge(Start,End)|RestOfEdges], CurPath, Start, End ). 
path_available_by_edge(Edges, [Edge|RestOfEdges], CurPath, Start, End ) :- path_available_by_edge(Edges, RestOfEdges, [Edge|CurPath], Start, End).
path_available_by_edge(Edges, [Edge|RestOfEdges], CurPath, Start, End ) :- ... .
*/

%- paths - compute the path from one node to another one


myappend([], Ys, Ys).
myappend([X|Xs], Ys, [X|Zs]) :- myappend(Xs, Ys, Zs).