%%%%%%%% ARITHMETIC

nat(0).
nat(s(X)) :- nat(X).

plus(0,Z,Z) :- nat(Z).
plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

times(0,_,0).
times(s(X),Y,Z) :- times(X,Y,XY), plus(XY, Y, Z).

%%%%%%%%%%%% meta

mgu(Term,Term).
% mgu(a(Y,b(X)),a(1,b(Z))).   % Y/1  Z/X
% mgu(a(X,2,W,4), a(Y,Y,Z,W)) % X/2  W/4  Y/2  Z/4
% mgu(append([a,b],[c,d],Ls), append([X|Xs],Ys,[X|Zs])).
%    % Ls / [a|Zs]  X / a  Xs / [b]  Ys / [c,d]

q(a).q(b).q(c).q(d).