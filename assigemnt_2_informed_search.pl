%first matrix [ [0,0,y],[1,0,b],[2,0,b],[3,0,b],[0,1,y],[1,1,y],[2,1,b],[3,1,b],[0,2,y],[1,2,b],[2,2,b],[3,2,b],[0,3,r],[1,3,y],[2,3,y],[3,3,y] ]
%second matrix [ [0,0,r],[1,0,r],[2,0,r],[3,0,b],[0,1,r],[1,1,b],[2,1,r],[3,1,r],[0,2,y],[1,2,r],[2,2,r],[3,2,b],[0,3,y],[1,3,r],[2,3,y],[3,3,y] ] 
%node looks like this [X,Y,Color]
%matrix is a list of these nodes
%first question query: search([0,0,y],[],[ [0,0,y],[1,0,b],[2,0,b],[3,0,b],[0,1,y],[1,1,y],[2,1,b],[3,1,b],[0,2,y],[1,2,b],[2,2,b],[3,2,b],[0,3,r],[1,3,y],[2,3,y],[3,3,y] ],4,4).
%second question query: search2([0,0,r],[],[1,3,r],[ [0,0,r],[1,0,r],[2,0,r],[3,0,b],[0,1,r],[1,1,b],[2,1,r],[3,1,r],[0,2,y],[1,2,r],[2,2,r],[3,2,b],[0,3,y],[1,3,r],[2,3,y],[3,3,y] ] ,4,4).
append([], L, L).
append([H|T], L2, [H|NT]):-
	append(T, L2, NT).
lengths([],0).
lengths([_|Tail], N):-
	lengths(Tail, TmpN),
	N is TmpN+1.
members(X, [X|_]).
members(X, [_|Tail]):-
	members(X, Tail).
%check 2 nodes same has color
samecolornode([_,_,C],[_,_,C]).
%check all list with same color
samecolor([_]).
samecolor([H,S|T]):-
	samecolornode(H,S),
	samecolor([S|T]),!.
%check 2 nodes are adjacent
isadjacent([X1,Y,_],[X2,Y,_]):-
	X1 is X2+1,!.
isadjacent([X1,Y,_],[X2,Y,_]):-
	X2 is X1+1,!.
isadjacent([X,Y1,_],[X,Y2,_]):-
	Y1 is Y2+1,!.
isadjacent([X,Y1,_],[X,Y2,_]):-
	Y2 is Y1+1,!.
%return color of the node by coordinates
getcolor([X,Y,_],Matrix,[X,Y,b]):-
	members([X,Y,b],Matrix),!.
getcolor([X,Y,_],Matrix,[X,Y,r]):-
	members([X,Y,r],Matrix),!.		
getcolor([X,Y,_],Matrix,[X,Y,y]):-
	members([X,Y,y],Matrix),!.
last([X], X).
last([_|T], X):-
	last(T, X),!.
%check if there is a cycle in the list
%design output
iscycle([H|T]):-
	last([H|T],X),
	samecolor([H|T]),
	isadjacent(H,X),
	lengths([H|T],R),
	R>3,
	append([H|T],[H],List),
	write("Search is complete!"), nl,
	write(List),!.
%if first element doesnt form cycle remove it and search rest of the list
iscycle([H|T]):-
	iscycle(T),!.
search(CurrentState, Visited,Matrix,N,M):-
	iscycle(Visited).
%move design	
search(CurrentState, Visited,Matrix,N,M):-
	moveright(CurrentState, Next,M),
	getcolor(Next,Matrix,NextState),	
	not(members(NextState, Visited)),
	append(Visited, [CurrentState], NewVisited),
	search(NextState, NewVisited,Matrix,N,M),!.
search(CurrentState, Visited,Matrix,N,M):-
	movedown(CurrentState, Next,N),
	getcolor(Next,Matrix,NextState),
	not(members(NextState, Visited)),
	append(Visited, [CurrentState], NewVisited), 
	search(NextState, NewVisited,Matrix,N,M),!.
search(CurrentState, Visited,Matrix,N,M):-
	moveleft(CurrentState, Next),
	getcolor(Next,Matrix,NextState),	
	not(members(NextState, Visited)),
	append(Visited, [CurrentState], NewVisited), 
	search(NextState, NewVisited,Matrix,N,M),!.
search(CurrentState, Visited,Matrix,N,M):-
	moveup(CurrentState, Next),
	getcolor(Next,Matrix,NextState),	
	not(members(NextState, Visited)),
	append(Visited, [CurrentState], NewVisited), 
	search(NextState, NewVisited,Matrix,N,M),!.

moveup([X,Y,_],[NX,Y,_]):-
NX is X-1,
NX>=0.
movedown([X,Y,_],[NX,Y,_],Size):-
NX is X+1,
NX<Size.
moveleft([X,Y,_],[X,NY,_]):-
NY is Y-1,
NY>=0.
moveright([X,Y,_],[X,NY,_],Size):-
NY is Y+1,
NY<Size.



abso(X,Y):-
	X<0,
	Y is -X,!.
abso(X,Y):-
	Y is X.
%output design
search2(Start,Path,Goal,Matrix,N,M):-
	last(Path,X),
	isadjacent(X,Goal),
	append(Path,[Goal],NewPath),
	write("Search is complete!"), nl,
	write(NewPath),!.
search2(Start,Path,Goal,Matrix,N,M):-
	getbest(Start,Goal,B,N,M,Matrix),
	not(members(B, Path)),
	append(Path, [Start], NewPath),
	search2(B,NewPath,Goal,Matrix,N,M),!.
%move design
search2(Start,Path,Goal,Matrix,N,M):-
	movedown(Start,DD,N),
	getcolor(DD,Matrix,D),
	samecolornode(D,Start),
	not(members(D, Path)),
	append(Path, [Start], NewPath),
	search2(D,NewPath,Goal,Matrix,N,M),!.
search2(Start,Path,Goal,Matrix,N,M):-
	moveright(Start,DD,M),
	getcolor(DD,Matrix,D),
	samecolornode(D,Start),
	not(members(D, Path)),
	append(Path, [Start], NewPath),
	search2(D,NewPath,Goal,Matrix,N,M),!.
search2(Start,Path,Goal,Matrix,N,M):-
	moveleft(Start,DD),
	getcolor(DD,Matrix,D),
	samecolornode(D,Start),
	not(members(D, Path)),
	append(Path, [Start], NewPath),
	search2(D,NewPath,Goal,Matrix,N,M),!.
search2(Start,Path,Goal,Matrix,N,M):-
	moveup(Start,DD),
	getcolor(DD,Matrix,D),
	samecolornode(D,Start),
	not(members(D, Path)),
	append(Path, [Start], NewPath),
	search2(D,NewPath,Goal,Matrix,N,M),!.

%how many nodes between node1 and goal
heuristic([X,Y,Co],[X1,Y1,Co2],C):-
samecolornode([X,Y,Co],[X1,Y1,Co2]),
X2 is X1-X,
abso(X2,X3),
Y2 is Y1-Y,
abso(Y2,Y3),
C is Y3+X3,!.
%return 10000 if node1 has different color than goal
heuristic([X,Y,Co],[X1,Y1,Co2],C):-
	not(samecolornode([X,Y,Co],[X1,Y1,Co2])),
	equal(10000,C),!.

min([],1000000).
min([H|T],MIN):- 
	min(T,MIN1),
 	H < MIN1,
	MIN is H,!.
min([H|T],MIN):- 
	min(T,MIN1),
 	H >= MIN1,
	MIN is MIN1,!.

equal(X,X).

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveleft(Start,LL),
moveright(Start,RR,M),
moveup(Start,UU),
getcolor(DD,Matrix,D),
getcolor(UU,Matrix,U),
getcolor(RR,Matrix,R),
getcolor(LL,Matrix,L),
heuristic(D,Goal,DH),
heuristic(L,Goal,LH),
heuristic(U,Goal,UH),
heuristic(R,Goal,RH),
min([DH,LH,UH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveleft(Start,LL),
moveright(Start,RR,M),
getcolor(DD,Matrix,D),
getcolor(RR,Matrix,R),
getcolor(LL,Matrix,L),
heuristic(D,Goal,DH),
heuristic(L,Goal,LH),
heuristic(R,Goal,RH),
min([DH,LH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveleft(Start,LL),
moveup(Start,UU),
getcolor(DD,Matrix,D),
getcolor(UU,Matrix,U),
getcolor(LL,Matrix,L),
heuristic(D,Goal,DH),
heuristic(L,Goal,LH),
heuristic(U,Goal,UH),
min([DH,LH,UH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
moveleft(Start,LL),
moveright(Start,RR,M),
moveup(Start,UU),
getcolor(UU,Matrix,U),
getcolor(RR,Matrix,R),
getcolor(LL,Matrix,L),
heuristic(L,Goal,LH),
heuristic(U,Goal,UH),
heuristic(R,Goal,RH),
min([LH,UH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveright(Start,RR,M),
moveup(Start,UU),
getcolor(DD,Matrix,D),
getcolor(UU,Matrix,U),
getcolor(RR,Matrix,R),
heuristic(D,Goal,DH),
heuristic(U,Goal,UH),
heuristic(R,Goal,RH),
min([DH,UH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveright(Start,RR,M),
getcolor(DD,Matrix,D),
getcolor(RR,Matrix,R),
heuristic(D,Goal,DH),
heuristic(R,Goal,RH),
min([DH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
moveright(Start,RR,M),
moveup(Start,UU),
getcolor(UU,Matrix,U),
getcolor(RR,Matrix,R),
heuristic(U,Goal,UH),
heuristic(R,Goal,RH),
min([UH,RH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
moveleft(Start,LL),
moveup(Start,UU),
getcolor(UU,Matrix,U),
getcolor(LL,Matrix,L),
heuristic(U,Goal,UH),
heuristic(L,Goal,LH),
min([UH,LH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

getbest(Start,Goal,B,N,M,Matrix):-
movedown(Start,DD,N),
moveleft(Start,LL),
getcolor(DD,Matrix,D),
getcolor(LL,Matrix,L),
heuristic(D,Goal,DH),
heuristic(L,Goal,LH),
min([DH,LH],Min),
get2(Start,Min,Goal,N,M,B,Matrix),!.

get2(Start,Min,Goal,N,M,B,Matrix):-
moveright(Start,RR,M),
getcolor(RR,Matrix,R),
heuristic(R,Goal,Min),
equal(B,R).

get2(Start,Min,Goal,N,M,B,Matrix):-
moveleft(Start,LL),
getcolor(LL,Matrix,L),
heuristic(L,Goal,Min),
equal(B,L).

get2(Start,Min,Goal,N,M,B,Matrix):-
movedown(Start,DD,N),
getcolor(DD,Matrix,D),
heuristic(D,Goal,Min),
equal(B,D).



get2(Start,Min,Goal,N,M,B,Matrix):-
moveup(Start,UU),
getcolor(UU,Matrix,U),
heuristic(U,Goal,Min),
equal(B,U).

