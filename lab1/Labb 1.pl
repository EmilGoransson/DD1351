

append([],L,L).
append([H|T],L,[H|R]) :- append(T,L,R).

appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]) :-
           appendEl(X, T, Y).


%% https://www.swi-prolog.org/pldoc/man?predicate=nth0/3
nth(N,L,E) :- nth(1,N,L,E).
nth(N,N,[H|_],H).
nth(K,N,[_|T],H) :- K1 is K+1, nth(K1,N,T,H).

%returns length
list_length([],0).
list_length([_|T],N) :- list_length(T,N1), N is N1+1.

%%kollar om arr1 är en delgrupp till arr2
subset([], []).
subset([H|T], [H|R]) :- subset(T, R).
subset([_|T], R) :- subset(T, R).

%
select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).

member(X,L) :- select(X,L,_).

memberchk(X,L) :- select(X,L,_), !.

add_Element([H|T], [H|Rest] ) :- %  CASE: IF head is unique, add head to R.
    add_Element(T, Rest).

%Uppgift 2

remove_dup(A, R) :- 
remove_dup(A, [], R).

remove_dup([], R, R).       % A = [] ?
remove_dup([X|A], Z, R) :-  
    member(X,A), !,         % Finns X (head) i A (tail) ?
    remove_dup(A,Z,R).      % Om ja kör koden igen utan head

remove_dup([X|A], Z, R) :- % Om nej: Lägg til head i listan R2 
    append([X],Z,R2),     
    remove_dup(A,R2,R).     % Kör om programmet med A (tailen) och listan R2

%Uppgift 3
partstringV2([], 0, []).
partstringV2(List, L, R) :-
    append(_, R2, List), % Vill få List efter append, hur får vi det? Ger flera alternativ via backtracking (spara i T).
    append(R, _, R2), % Har R och något _ (som vi ej bryr oss om) , vill få T, vad kan/ska då R vara? (sparar detta i R (som vi skriver ut)).
    list_length(R, L), %Ger oss längden på R och sparar det i L.
    L =\= 0.  % Löser problem med att vi skriver ut L = 0 mer än en gång. (programmet falskt då R = []).


%Uppgift 4

%Ritar grafen
edge(1,2).
edge(1,3).
edge(1,4).
edge(2,3).
edge(3,5).
edge(3,2).
edge(4,5).

path(X, Y, Path) :- % Startnod X, Slutnod Y, Path = Där vi sparar vägen
    path(X, Y, [X, Y], P1), % går till path(X, Y, _, Path)
    Path = [X|P1].    

path(X, Y, _, Path) :-
    edge(X, Y), % Finns det någon väg direkt till Y? 
    Path = [Y]. % Ja, spara noden i Path-variabeln 

path(X, Y, Visited, Path) :-
    edge(X, Z),
    \+member(Z, Visited), %%Kollar om vi redan varit på den noden, om ja, fail. Om nej, true och kör vidare
    path(Z, Y, [Z|Visited], P1), %%Går tillbaka till 3
    Path = [Z|P1]. %%Skriver ut ett alternativ





