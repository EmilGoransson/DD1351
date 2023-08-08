%Premiss=[q].

%Goal='or(p,q)'.

%Proof=[[1, q,premise],[2, or(p,q), orint2(1)]].

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
%andint   
valid_proof(Premiss,Goal,[[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]|Rest], ProofUntilNow):-
    member([Row1, CurProof1, _], ProofUntilNow),!,
    member([Row2, CurProof2, _], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]], NewProofUntilNow),
    valid_proof(Premiss, Goal, Rest, NewProofUntilNow).

%orint1
valid_proof(Premiss,Goal,[[Row, or(CurProof1, CurProof2), orint1(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof1, _], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, or(CurProof1, CurProof2), orint1(Row1)]], NewProofUntilNow),
    valid_proof(Premiss,Goal, Rest,NewProofUntilNow).

%orint2
valid_proof(Premiss,Goal,[[Row, or(CurProof1, CurProof2), orint2(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof2, _], ProofUntilNow),!,
    append(ProofUntilNow, [[Row, or(CurProof2, CurProof1), orint2(Row1)]], NewProofUntilNow),
    valid_proof(Premiss,Goal, Rest,NewProofUntilNow).



