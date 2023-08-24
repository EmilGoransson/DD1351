% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.
%
% Should evaluate to true iff the sequent below is valid.
%
% (T,L), S |- F
% U
% To execute: consult('your_file.pl'). verify('input.txt').
% Literals
check(_, L, S, [], F):-
    write('first'),
    member([S, LabelState], L),
    member(F, LabelState).

check(_, L, S, [], neg(F)):-
    write('neg'),
    member([S, LabelState], L),
    \+member(F, LabelState).  
% And
check(T, L, S, [], and(F,G)):-
    write('and'),
    check(T, L, S, [], F),
    check(T, L, S, [], G).
% Or
check(T, L, S, [], or(F,G)):-
    write('or'),
    check(T, L, S, [], F) ; check(T, L, S, [], G).
% AX - All Next state
check(T, L, S, [], ax(F)):-
    write('AX'),
    %gets connected paths
    member([S, Paths], T),
    %checks all elements in Paths list
    check_all_states(T, L, Paths, [], F).
% EX
check(T, L, S, [], ex(F)):-
    write('EX').
% AG
% EG
% EF
% AF

check_all_states(_, _, [], _, _).
check_all_states(T, L, [CurPath|Rest], U, F):-
    check(T, L, CurPath, [], F),
    check_all_states(T, L, Rest, U, F).