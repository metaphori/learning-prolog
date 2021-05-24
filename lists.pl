createframe(Name,X,Y):-
new_object(’javax.swing.JFrame’,[],Obj), 
Obj <- setTitle(Name), 
Obj <- setSize(X,Y), 
Obj <- setVisible(true).