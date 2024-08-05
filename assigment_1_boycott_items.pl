:-consult(data).
:-dynamic(item/3).
:-dynamic(alternative/2).
:-dynamic(boycott_company/2).
:-discontiguous(totalPrice/3).
countlist([],0).
countlist([_|T],R):-
	countlist(T,R1),
	R is R1+1.
isitem(Name):-item(Name,_,_).
%Q1
list_orders(CustUserName, L) :-
    addOrderToList(CustUserName, [], L).


addOrderToList(CustUserName, Temp, Result) :-
    customer(CustID, CustUserName),
    order(CustID, OrderID, Items),
    \+ order_in_list(order(CustID, OrderID, Items), Temp),
    addOrderToList(CustUserName, [order(CustID, OrderID, Items) | Temp], Result),
    !.
addOrderToList(_, Temp, Temp).

order_in_list(Order, [Order|_]).
order_in_list(Order, [_|T]) :-
    	order_in_list(Order, T).

%Q2
count_orders(Customer,Count):-
	list_orders(Customer, L),
	countlist(L,Count).
%Q3
getiteminorderbyid(Customer,Num,Items):-
	customer(N,Customer),
	order(N,Num,Items),!.
%Q4
getnumofitems(Customer,Num,Count):-
	getiteminorderbyid(Customer,Num,Items),
	countlist(Items,Count).

%Q5
totalPrice([],Price,Price).
totalPrice([H|T],Price):-totalPrice([H|T],Price,0).
totalPrice([H|T],Price,Result):-
	item(H,_,P),
	Newresult is Result+P,
	totalPrice(T,Price,Newresult).

calcpriceoforder(Customer,Num,TotalPrice):-
	getiteminorderbyid(Customer,Num,Items),
	totalPrice(Items,TotalPrice,0).
%Q6

isboycott(Name):-
	boycott_company(Name,_).
isboycott(Name):-
	isitem(Name),
	item(Name,Company,_),
	boycott_company(Company,_).

%Q7
whytoboycott(Name,Justification):-
	boycott_company(Name,Justification).
whytoboycott(Name,Justification):-
	isitem(Name),
	item(Name,Company,_),
	boycott_company(Company,Justification).
%Q8
newlist([],[]).
newlist([H|T],R):-
	isboycott(H),
	newlist(T,R).
newlist([H|T],[H|R]):-
	\+ isboycott(H),
	newlist(T,R).
removeboycottitems(Customer,Num,Newlist):-
	getiteminorderbyid(Customer,Num,Items),
	newlist(Items,Newlist),!.
%Q9:
replaceBoycottItemsFromAnOrder(Username, OrderID, NewOrderItems) :-
    customer(CustomerID, Username),
    order(CustomerID, OrderID, OrderItems),
    replaceBoycottItems(OrderItems, NewOrderItems),!.

replaceBoycottItems([], []).
replaceBoycottItems([Item|Rest], [Item|NewRest]) :-
    \+ isboycott(Item),
    replaceBoycottItems(Rest, NewRest).
replaceBoycottItems([Item|Rest], [Alternative|NewRest]) :-
    isboycott(Item),
    alternative(Item, Alternative),
    replaceBoycottItems(Rest, NewRest).
%Q10

calcPriceAfterReplace(Customer,ID,NewList,TotalPrice):-
	replaceBoycottItemsFromAnOrder(Customer,ID,NewList),
	totalPrice(NewList,TotalPrice).
%Q11

getTheDifferenceInPriceBetweenItemAndAlternative(Item,Alter,Price):-
	alternative(Item,Alter),
	item(Item,_,L1),
	item(Alter,_,L2),
	Price is L1-L2.

%Q12
add_item(Item, Brand, Price) :-
    	assert(item(Item, Brand, Price)).
add_alternative(Item,Alternate):-
	assert(alternative(Item,Alternate)).
add_boycott(Company,Justification):-
	assert(boycott_company(Company,Justification)).
remove_item(Item, Brand, Price) :-
	item(Item, Brand, Price),
    	retract(item(Item, Brand, Price)).
remove_alternative(Item,Alternate):-
	alternative(Item,Alternate),
	retract(alternative(Item,Alternate)).
remove_boycott(Company,Justification):-
	boycott_company(Company,Justification),
	retract(boycott_company(Company,Justification)).