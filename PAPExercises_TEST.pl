:- begin_tests(pap_exercises_test_suite).
:- use_module('PAPExercises.pl', [height/2, search_in_bstree/2, flatten_bstree/2, bstree_insert/3, bstree_check/1, bad/1]).
% if imported predicates are not explicitly defined, fully qualified names (e.g. pap_exercises:height/2) must be used

test(binary_tree)          :- height( btree(_, void, void),   0 ).

test(failing_test, [fail])         :- bad(5). % IMPORTANT , testing for errors!!!!

test(search_trees_search1) :- search_in_bstree( bstree(10,void,void), X), assertion(X=10).

test(search_trees_search2) :- search_in_bstree( bstree(8,bstree(4,void,void),void), 4),
                              search_in_bstree( bstree(8,void,bstree(10,void,bstree(12,void,void))), 12).

test(search_trees_flatten) :- flatten_bstree( bstree(10, bstree(5,void,void), bstree(20,void,void)), [5,10,20] ),
                              flatten_bstree( bstree(10, bstree(9, bstree(7, void, bstree(8, void, void)), void), void ), [7,8,9,10] ),
                              flatten_bstree( bstree(10, bstree(9, bstree(8, bstree(7, void, void), void), void), void ), X ), assertion(X=[7,8,9,10]).

test(search_trees_insert)  :- bstree_insert( 
                                bstree(10, bstree(5,void,void), bstree(20,void,void)),
                                25,
                                bstree(10, bstree(5,void,void), bstree(20,void,bstree(25,void,void)))
                              ),
                              bstree_insert( 
                                bstree(10, bstree(5,void,void), bstree(20,void,void)),
                                7,
                                bstree(10, bstree(5,void,bstree(7,void,void)), bstree(20,void,void))
                              ).

test(search_trees_check)   :- bstree_check( bstree(10, bstree(5,void,void), bstree(20,void,void)) ),
                              bstree_check( bstree(10, bstree(9, bstree(8, bstree(7, void, void), void), void), void) ),
                              bstree_check( bstree(10, bstree(9, bstree(7, void, bstree(8, void, void)), void), void) ).



:- end_tests(pap_exercises_test_suite).

