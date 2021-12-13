% Drew Martin
% IT 327 Prog 4
% ch 22, ex 2: 10 %
% ch 22, ex 3: 15 %
% ch 22, ex 5: 20 %
% ch 22, ex 6: 25 %
% The attached logic puzzle: 30 %
% Provide a separate text file with sample queries that would test each of these 
% named test_queries.txt
% Provide a third file name output.txt that shows expected results to those queries


% Exercise 2
% a predicate maxlist(L,M) that takes a list L of numbers and unifies M with the
% maximum number in the list
% H is head T is tail
maxlist([L], L).
maxlist([H|T], H) :-
    maxlist(T, M),
    H > M.
maxlist([H|T], M) :-
    maxlist(T, M),
    H =< M.


% Exercise 3
% a predicate ordered(L) that succeeds if and only if the list of numbers L
% is in non-decreasing order
% each element is less than or equal to the next
ordered([_]).
ordered([A, B|T]) :-
    A =< B,
    ordered([B|T]).


% Exercise 5
% a predicate nqueens(N,X) that takes an integer N and finds a solution X 
% to the N-queens problem
% base some of this off of eight queens example in textbook
% nocheck takes a queen X/Y and list of the queens and succeeds if the X/Y
% queen holds none of the others in check
nocheck(_, []).
nocheck(X/Y, [X1/Y1|Rest]) :-
    Y =\= Y1,
    abs(Y1-Y) =\= abs(X1-X),
    nocheck(X/Y, Rest).
% legal succeeds if L is a legal placement of queens, all coordinates in 
% range and no queen in check
legal([], _).
legal([X/Y|Rest], L) :-
    legal(Rest, L),
    member(Y, L),
    nocheck(X/Y, Rest).
% create lists for nqueens 
generatelist(1, Q, [Q/_], [Q]).
generatelist(N, Q, [Q/_|Tailx], [Q|Tail]) :-
    X is N - 1,
    Y is Q + 1,
    generatelist(X, Y, Tailx, Tail).
% driver for nqueens solution
nqueens(N, X) :-
    generatelist(N, 1, X, L),
    legal(X, L).


% Exercise 6
% Define a predicate subsetsum(L, Sum, SubL) that takes a list L 
% of numbers and a number Sum
% and unifies SubL with a subsequence of L such that the sum of
% the numbers in SubL is Sum
% subset forms subset lists that would be checked with sum
subset([], []).
subset([H|Tail1], [H|Tail2]) :-
    subset(Tail1, Tail2).
subset([_|Tail1], Tail2) :-
    subset(Tail1, Tail2).
% for sum check
sum([], 0).
sum([H|T], Sum) :-
    sum(T, Restof),
    Sum is H + Restof.
% subset sum
subsetsum(L, Sum, SubL) :-
    subset(L, SubL),
    sum(SubL, Sum).


% logic puzzle doctor and patient problem
% First names: [jack, janet, jean, jill, jim]
% Last names: [palmer, johnson, richards, french, solomon]
% Doctor names: [aronson, carter, noble, pershy, sands]
% Specialties: [dermatologist, obstetrician, orthopedist, 
% podiatrist, surgeon]
% Three of the people are female: janet, jean, and jill
% Hints
% Jim Johnson did not go to Dr. Pershy
% The three women are: the one who visited Dr. Noble, 
% the one whose last name is Palmer
% and the one who visited the dermatologist
% Ms. Richards visited the surgeon
% The orthopedist, who is not French's doctor, is not Dr. Carter
% A woman went to Dr. Aronson, but she is not Jean
% Janet is not the woman who saw the obstetrician
% The obstetrician is not Dr. Carter
% Jill's last name is Solomon

% list of tuples with persons information
persons(0, []) :- !.
persons(N, [(_Fname,_Lname,_Doctor,_Specialty)|T]) :- N1 is N-1, persons(N1,T).
% person predicate 
person(1, [H|_], H) :- !.
person(N, [_|T], R) :- N1 is N-1, person(N1, T, R).

% hints
% hint 1 jim johnson didn't go dr pershy
hint1([(jim,johnson,doctor,_)]) :-
    doctor = noble;
    doctor = aronson;
    doctor = sands;
    doctor = carter.
hint1([_|T]) :- hint1(T).
% hint 2 three women, one visit noble, one last name palmer, one visits derm
hint2([(women,palmer,_,_)|_]) :-
    women = janet;
    women = jill;
    women = jean.
hint2([_|T]) :- hint2(T).
% splitting hint 2 into seperate hints
hint10([(women,_,noble,_)|_]) :-
    women = janet;
    women = jill;
    women = jean.
hint10([_|T]) :- hint10(T).
hint11([(women,_,_,dermatologist)|_]) :-
    women = janet;
    women = jill;
    women = jean.
hint11([_|T]) :- hint11(T).
% hint 3 ms richards visited surgeon
% jill is already solomon last name
hint3([(women,richards,_,surgeon)|_]) :-
    women = jean;
    women = janet.
hint3([_|T]) :- hint3(T).
% hint 4 ortho is not frenchs doctor
hint4([(_,lname,_,orthopedist)|_]) :-
    lname = johnson;
    lname = palmer;
    lname = solomon.
hint4([_|T]) :- hint4(T).
% hint 5 a women went to aronson not jean though
hint5([(women,_,aronson,_)|_]) :-
    women = jill;
    women = janet.
hint5([_|T]) :- hint5(T).
% hint 6 janet did not see obsetrician, was a women though
hint6([(women,_,_,obstetrician)|_]) :-
    women = jill;
    women = jean.
hint6([_|T]) :- hint6(T).
% hint 7 obsetrician not dr carter
hint7([(_,_,doctor,obstetrician)|_]) :-
    doctor = pershy;
    doctor = noble;
    doctor = sands;
    doctor = aronson.
hint7([_|T]) :- hint7(T).
% hint 8 jill last name is solomon
hint8([(jill,solomon,_,_)|_]).
hint8([_|T]) :- hint8(T).
% second part of hint 4, ortho is not dr carter
hint9([(_,_,doctor,orthopedist)|_]) :-
    doctor = aronson;
    doctor = noble;
    doctor = pershy;
    doctor = sands.
hint9([_|T]) :- hint9(T).

% solution
solution(Persons) :-
    persons(5, Persons),
    hint1(Persons),
    hint2(Persons),
    hint3(Persons),
    hint4(Persons),
    hint5(Persons),
    hint6(Persons),
    hint7(Persons),
    hint8(Persons),
    hint9(Persons),
    hint10(Persons),
    hint11(Persons).

% originally I was getting output similar to below so I know it was working to solve puzzle and create list of lists
% as I added hints, it started returning as false
% solution(Persons).
% Persons = [(jim, johnson, _3520, _3562),  (jill, solomon, _3584, _3586),  (_3596, _3602, _3608, _3610),  (_3620, _3626, _3632, _3634),  (_3644, _3650, _3656, _3658)] .