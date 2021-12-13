% Drew Martin
% IT 327 Prog 4
% ch 22, ex 2: 10 %
% ch 22, ex 3: 15 %
% ch 22, ex 5: 20 %
% ch 22, ex 6: 25 %
% The attached logic puzzle: 30 %
% Provide a separate text file with sample queries that would test each of these named test_queries.txt
% Provide a third file name output.txt that shows expected results to those queries


% Exercise 2
% a predicate maxlist(L,M) that takes a list L of numbers and unifies M with the maximum number in the list
maxlist([A], A).
maxlist([H|T], H) :-
    maxlist(T, Mt),
    H > Mt.
maxlist([H|T], Mt) :-
    maxlist(T, Mt),
    H =< Mt.


% Exercise 3
% a predicate ordered(L) that succeeds if and only if the list of numbers L is in non-decreasing order - each element is less than or equal to the next
ordered([_]).
ordered([A, B|T]) :-
    A =< B,
    ordered([B|T]).


% Exercise 5
% a predicate nqueens(N,X) that takes an integer N and finds a solution X to the N-queens problem
% nocheck(X/Y, L) takes a queen X/Y and a list of queens. We succeed if and only if the X/Y queen holds none of the others in check
nocheck(_, []).
nocheck(X/Y, [X1/Y1|Rest]) :-
    Y =\= Y1,
    abs(Y1-Y) =\= abs(X1-X),
    nocheck(X/Y, Rest).
% legal(L) succeeds if L is a legal placement of queens: all coordinates in range and no queen in check
legal([], _).
legal([X/Y|Rest], L) :-
    legal(Rest, L),
    member(Y, L),
    nocheck(X/Y, Rest).
createlists(1, C, [C/_], [C]).
createlists(N, C, [C/_|Tx], [C|Tl]) :-
    N1 is N - 1,
    C1 is C + 1,
    createlists(N1, C1, Tx, Tl).
nqueens(N, X) :-
    createlists(N, 1, X, L),
    legal(X, L).


% Exercise 6
% Define a predicate subsetsum(L, Sum, SubL) that takes a list L of numbers and a number Sum
% and unifies SubL with a subsequence of L such that the sum of the numbers in SubL is Sum
subset([], []).
subset([H|T1], [H|T2]) :-
    subset(T1, T2).
subset([_|T1], T2) :-
    subset(T1, T2).
% for sum
sum([], 0).
sum([H|T], S) :-
    sum(T, S1),
    S is H + S1.
% subset sum
subsetsum(L, Sum, SubL) :-
    subset(L, SubL),
    sum(SubL, Sum).


% logic puzzle doctor and patient problem
% First names: [jack, janet, jean, jill, jim]
% Last names: [palmer, johnson, richards, french, solomon]
% Doctor names: [aronson, carter, noble, pershy, sands]
% Specialties: [dermatologist, obstetrician, orthopedist, podiatrist, surgeon]
% Three of the people are female: janet, jean, and jill
% Hints
% Jim Johnson did not go to Dr. Pershy
% The three women are: the one who visited Dr. Noble, the one whose last name is Palmer
% and the one who visited the dermatologist
% Ms. Richards visited the surgeon
% The orthopedist, who is not French's doctor, is not Dr. Carter
% A woman went to Dr. Aronson, but she is not Jean
% Janet is not the woman who saw the obstetrician
% The obstetrician is not Dr. Carter
% Jill's last name is Solomon