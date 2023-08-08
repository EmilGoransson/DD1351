%Premiss=[p, neg(p)].

%Goal='q'.

%Proof=[[1, neg(neg(and(p,q))),premise],[2, and(p,q),negnegel(1)],[3, q,andel2(2) ]].

valid_proof(Premiss, Goal, Proof):-
    valid_proof(Premiss, Goal, Proof, []).

%checks if list is empty.
%Maybe add condition that checks if goal == last row?
valid_proof(_,_,[],_).

%premise
valid_proof(Premiss, Goal, [[Row, CurProof, premise]|Rest], ProofUntilNow):-
    member(CurProof, Premiss),!,
    append(ProofUntilNow,[[Row, CurProof, premise]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).

%imp, impel, implication elimination
valid_proof(Premiss, Goal, [[Row, CurProof, impel(Row1,Row2)]|Rest], ProofUntilNow):-
    member([Row1, AltProof,_], ProofUntilNow),!,
    member([Row2, imp(AltProof,CurProof),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, impel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).

%andel1
valid_proof(Premiss, Goal, [[Row, CurProof, andel1(Row1)]|Rest], ProofUntilNow):-
    member([Row1, and(CurProof,_),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, andel1(Row1)]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).

%andel2
valid_proof(Premiss, Goal, [[Row, CurProof, andel2(Row1)]|Rest], ProofUntilNow):-
    member([Row1, and(_,CurProof),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row,CurProof,andel2(Row1)]], NewProofUntilNow),
    valid_proof(Premiss,Goal,Rest,NewProofUntilNow).

%negel
valid_proof(Premiss,Goal, [[Row, CurProof, negel(Row1, Row2)]|Rest], ProofUntilNow):-
    member([Row1, AltProof, _], ProofUntilNow),!,
    member([Row2, neg(AltProof),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, negel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).
%contel
valid_proof(Premiss, Goal, [[Row, CurProof, contel(Row1)]|Rest], ProofUntilNow):-
    member([Row1, cont, _], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, contel(Row1)]], NewProofUntilNow),
    valid_proof(Premiss,Goal,Rest,NewProofUntilNow).
%negnegel
valid_proof(Premiss,Goal, [[Row, CurProof, negnegel(Row1)]|Rest], ProofUntilNow):-
    member([Row1, neg(neg(CurProof)),_], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, CurProof, negnegel(Row1)]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).

    



