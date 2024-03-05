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
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).
    

check(_, L, S, [], F):-
    member([S, LabelState], L),
    member(F, LabelState).

check(_, L, S, [], neg(F)):-
    member([S, LabelState], L),
    \+member(F, LabelState).  
% And
check(T, L, S, [], and(F,G)):-
    check(T, L, S, [], F),
    check(T, L, S, [], G).
% Or
check(T, L, S, [], or(F,G)):-
    (
        check(T, L, S, [], F) 
    ;   check(T, L, S, [], G)
    ).
% AX - All Next state
check(T, L, S, [], ax(F)):-
    %gets connected paths
    member([S, Paths], T),
    %checks all elements in Paths list
    check_all_states(T, L, Paths, [], F).
% EX
check(T, L, S, [], ex(F)):-
    member([S, Paths], T),
    check_all_atleast_one_states(T, L, Paths, [], F).
% AG1
check(T, L, S, U, ag(F)):-
    member(S, U).
%AG2
checkG(T, L, S, U, F):-
    \+member(S,U),
    check(T, L, S, [], F),
    member([S, Paths], T).
%
check(T, L, S, U, ag(F)):-
    checkG(T, L, S, U, F),
    check_all_states(T, L, Paths, [S|U], ag(F)).
% EG1 Basecase
check(T, L, S, U, eg(F)):-
    member(S, U).

% EG2, Same as AG2 just at least one state
check(T, L, S, U, eg(F)):-
    checkG(T, L, S, U, F),

    check_all_atleast_one_states(T, L, Paths, [S|U], eg(F)).

% EF1
check(T, L, S, [], ef(F)).

% EF2
check(T, L, S, [], ef(F)).


% AF1
check(T, L, S, [], af(F)).

% AF2
check(T, L, S, [], af(F)).


check_all_states(_, _, [], _, _).
check_all_states(T, L, [CurPath|Rest], U, F):-
    check(T, L, CurPath, [], F),
    check_all_states(T, L, Rest, U, F).

check_all_atleast_one_states(T, L, [CurPath|Rest], U, F):-
    (
        check(T, L, CurPath, [], F) 
    ;   check_all_atleast_one_states(T, L, Rest, U, F)
    ).