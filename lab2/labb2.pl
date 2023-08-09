%Premise=[imp(p, q), p].

%Goal='p'.

%Proof=[[1, imp(p,q), premise],[2, p,        premise],[3, q,        impel(2,1)]].

verify(InputFileName):-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof).

valid_proof(Premise, Goal, Proof):-
    valid_proof(Premise, Goal, Proof, []).

%checks if list is empty.
%Maybe add condition that checks if goal == last row?
valid_proof(_,_,[],_).

%premise
valid_proof(Premise, Goal, [[Row, CurProof, premise]|Rest], ProofUntilNow):-
    member(CurProof, Premise) ,
    append(ProofUntilNow,[[Row, CurProof, premise]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%imp, impel, implication elimination
valid_proof(Premise, Goal, [[Row, CurProof, impel(Row1,Row2)]|Rest], ProofUntilNow):-
    member([Row1, AltProof,_], ProofUntilNow) ,
    member([Row2, imp(AltProof,CurProof),_], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, CurProof, impel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%andel1
valid_proof(Premise, Goal, [[Row, CurProof, andel1(Row1)]|Rest], ProofUntilNow):-
    member([Row1, and(CurProof,_),_], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, CurProof, andel1(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%andel2
valid_proof(Premise, Goal, [[Row, CurProof, andel2(Row1)]|Rest], ProofUntilNow):-
    member([Row1, and(_,CurProof),_], ProofUntilNow) ,
    append(ProofUntilNow, [[Row,CurProof,andel2(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal,Rest,NewProofUntilNow).

%negel
valid_proof(Premise,Goal, [[Row, CurProof, negel(Row1, Row2)]|Rest], ProofUntilNow):-
    member([Row1, AltProof, _], ProofUntilNow) ,
    member([Row2, neg(AltProof),_], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, CurProof, negel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).
%contel
valid_proof(Premise, Goal, [[Row, CurProof, contel(Row1)]|Rest], ProofUntilNow):-
    member([Row1, cont, _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, CurProof, contel(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal,Rest,NewProofUntilNow).
%negnegel
valid_proof(Premise,Goal, [[Row, CurProof, negnegel(Row1)]|Rest], ProofUntilNow):-
    member([Row1, neg(neg(CurProof)),_], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, CurProof, negnegel(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).
%andint   
valid_proof(Premise,Goal,[[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]|Rest], ProofUntilNow):-
    member([Row1, CurProof1, _], ProofUntilNow) ,
    member([Row2, CurProof2, _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%orint1
valid_proof(Premise,Goal,[[Row, or(CurProof1, CurProof2), orint1(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof1, _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, or(CurProof1, CurProof2), orint1(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal, Rest,NewProofUntilNow).

%orint2
valid_proof(Premise,Goal,[[Row, or(CurProof1, CurProof2), orint2(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof2, _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, or(CurProof2, CurProof1), orint2(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal, Rest,NewProofUntilNow).

%LEM
valid_proof(Premise, Goal, [[Row, or(CurProof, neg(CurProof)), lem]|Rest], ProofUntilNow):-
    append(ProofUntilNow, [[Row, or(CurProof, neg(CurProof), lem)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%negnegint
valid_proof(Premise,Goal, [[Row, neg(neg(CurProof)), negnegint(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof, _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, neg(neg(CurProof)), negnegint(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%MT
valid_proof(Premise, Goal, [[Row, neg(CurProof), mt(Row1, Row2)]|Rest], ProofUntilNow):-
    member([Row1, imp(CurProof, AltProof),_], ProofUntilNow) ,
    member([Row2, neg(AltProof), _], ProofUntilNow) ,
    append(ProofUntilNow, [[Row, neg(CurProof), mt(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).

%Copy
valid_proof(Premise, Goal, [[Row, CurProof, copy(Row1)]|Rest], ProofUntilNow):-
    member([Row1, CurProof, _], ProofUntilNow),
    append(ProofUntilNow, [Row, CurProof, copy(Row1)], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow).