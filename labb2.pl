%Premiss=[imp(p, q), p].

%Goal='q'.

%Proof=[[1, imp(p,q), premise],[2, p,premise],[3, q,impel(2,1)]].

valid_proof(Premiss, Goal, Proof):-
    valid_proof(Premiss, Goal, Proof, []).

%stops when proof is at end
valid_proof(_, _, [],_).


valid_proof(Premiss, Goal, [[Row, CurProof, premise]|Rest], ProofUntilNow):-
    member(CurProof, Premiss),!,
    writeln(CurProof),
    append(ProofUntilNow,[[Row, CurProof, premise]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).
%imp, impel, implication elimination
valid_proof(Premiss, Goal, [[Row, CurProof, impel(Row1,Row2)]|Rest], ProofUntilNow):-
    writeln(CurProof),
    member([Row1, AltProof,_], ProofUntilNow),!,
    member([Row2, imp(AltProof,CurProof),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, premise]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).


    

    



