Premiss=[imp(p, q), p].

Goal='q'.

Proof=[[1, imp(p,q), premise],[2, p,premise],[3, q,impel(2,1)]].

valid_proof(Premiss, Goal, Proof):-
    valid_proof(Premiss, Goal, Proof, Proof).

%stops when proof is at end
valid_proof(_, _, []).


valid_proof(Premiss, Goal, [[Row, CurProof, premise]|Rest], AllProof):-
    member(CurProof, Premiss),!,
    writeln(CurProof),
    valid_proof(Premiss, Goal, Rest, AllProof).
%imp, impel, implication elimination
valid_proof(Premiss, Goal, [[Row, CurProof, impel(Row1,Row2)]|Rest], AllProof):-
    member([Row1, AltProof,_], AllProof),!,
    member([Row2, imp(AltProof,CurProof),_], AllProof),!.

    

    



