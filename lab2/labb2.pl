verify(InputFileName):-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof).

%checks if goal exists at end of list. 
goal_is_last(Goal, [[_,Goal,_]|[]]).
goal_is_last(Goal, [_|Tail]):-
    goal_is_last(Goal, Tail).

valid_proof(Premise, Goal, Proof):-
    goal_is_last(Goal, Proof),
    valid_proof(Premise, Goal, Proof, [], []).

%checks if list is empty.
%Maybe add condition that checks if goal == last row?
valid_proof(_,_,[],_,_).

%premise
valid_proof(Premise, Goal, [[Row, CurProof, premise]|Rest], ProofUntilNow, AssumptProof):-
    member(CurProof, Premise),
    append(ProofUntilNow,[[Row, CurProof, premise]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%imp, impel, implication elimination
valid_proof(Premise, Goal, [[Row, CurProof, impel(Row1,Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, AltProof,_], ProofUntilNow) ,
    member([Row2, imp(AltProof,CurProof),_], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, CurProof, impel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%andel1
valid_proof(Premise, Goal, [[Row, CurProof, andel1(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, and(CurProof,_),_], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, CurProof, andel1(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%andel2
valid_proof(Premise, Goal, [[Row, CurProof, andel2(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, and(_,CurProof),_], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row,CurProof,andel2(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal,Rest,NewProofUntilNow, AssumptProof).

%negel
valid_proof(Premise,Goal, [[Row, CurProof, negel(Row1, Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, AltProof, _], ProofUntilNow)  ,
    member([Row2, neg(AltProof),_], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, CurProof, negel(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).
%contel
valid_proof(Premise, Goal, [[Row, CurProof, contel(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, cont, _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, CurProof, contel(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal,Rest,NewProofUntilNow, AssumptProof).
%negnegel
valid_proof(Premise,Goal, [[Row, CurProof, negnegel(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, neg(neg(CurProof)),_], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, CurProof, negnegel(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).
%andint   
valid_proof(Premise,Goal,[[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof1, _], ProofUntilNow)  ,
    member([Row2, CurProof2, _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, and(CurProof1, CurProof2), andint(Row1,Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%orint1
valid_proof(Premise,Goal,[[Row, or(CurProof1, CurProof2), orint1(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof1, _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, or(CurProof1, CurProof2), orint1(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal, Rest,NewProofUntilNow, AssumptProof).

%orint2
valid_proof(Premise,Goal,[[Row, or(CurProof1, CurProof2), orint2(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof2, _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, or(CurProof2, CurProof1), orint2(Row1)]], NewProofUntilNow),
    valid_proof(Premise,Goal, Rest,NewProofUntilNow, AssumptProof).

%LEM
valid_proof(Premise, Goal, [[Row, or(CurProof, neg(CurProof)), lem]|Rest], ProofUntilNow, AssumptProof):-
    append(ProofUntilNow, [[Row, or(CurProof, neg(CurProof), lem)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%negnegint
valid_proof(Premise,Goal, [[Row, neg(neg(CurProof)), negnegint(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof, _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, neg(neg(CurProof)), negnegint(Row1)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%MT
valid_proof(Premise, Goal, [[Row, neg(CurProof), mt(Row1, Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, imp(CurProof, AltProof),_], ProofUntilNow)  ,
    member([Row2, neg(AltProof), _], ProofUntilNow)  ,
    append(ProofUntilNow, [[Row, neg(CurProof), mt(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%Copy
valid_proof(Premise, Goal, [[Row, CurProof, copy(Row1)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof, _], ProofUntilNow) ,
    append(ProofUntilNow, [Row, CurProof, copy(Row1)], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%Assumption
valid_proof(Premise, Goal, [[[Row, CurProof, assumption]|RestBox]|Rest2], ProofUntilNow, AssumptProof):-
    append(ProofUntilNow, [[Row, CurProof, assumption]], NewProofUntilNow),
    append(AssumptProof, [[Row, CurProof, assumption]|RestBox],NewAssumptProof),
    %here we check so that the boxproof follows all the rules using reqursion,
    %we treat it like a normal proof besides the fact that goal_is_last is ignored/3. 

    valid_proof(Premise, [], RestBox, NewProofUntilNow, []),
    valid_proof(Premise, Goal, Rest2, ProofUntilNow, NewAssumptProof).
    
%impint
valid_proof(Premise, Goal, [[Row, imp(CurProof1, CurProof2), impint(Row1, Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof1, assumption], AssumptProof) ,
    member([Row2, CurProof2, _], AssumptProof) ,
    append(ProofUntilNow, [[Row, imp(CurProof1, CurProof2), impint(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).
%negint
valid_proof(Premise, Goal, [[Row, neg(CurProof), negint(Row1, Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, CurProof, assumption], AssumptProof) ,
    member([Row2, cont, _], AssumptProof) ,
    append(ProofUntilNow, [[Row, neg(CurProof), negint(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

%orel
valid_proof(Premise, Goal, [[Row, CurProof, orel(Row1, Row2, Row3, Row4, Row5)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, or(AltProof1, AltProof2), _], ProofUntilNow) ,
    member([Row2, AltProof1, assumption], AssumptProof) ,
    member([Row3, CurProof, _], AssumptProof) ,
    member([Row4, AltProof2, assumption], AssumptProof) ,
    member([Row5, CurProof, _], AssumptProof) ,
    append(ProofUntilNow, [[Row, CurProof, orel(Row1, Row2, Row3, Row4, Row5)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).
%pbc
valid_proof(Premise, Goal, [[Row, CurProof, pbc(Row1, Row2)]|Rest], ProofUntilNow, AssumptProof):-
    member([Row1, neg(CurProof), assumption], AssumptProof) ,
    member([Row2, cont, _], AssumptProof) ,
    append(ProofUntilNow, [[Row, CurProof, pbc(Row1, Row2)]], NewProofUntilNow),
    valid_proof(Premise, Goal, Rest, NewProofUntilNow, AssumptProof).

/* VALID NON TRIVIAL PROOF WRITTEN FORMAT
PREMISE:
GOAL:
PROOF:

[r,imp(p, and(r,q))].
imp(p,and(q,r)).
[
    [1, r,                premise],
    [2, imp(p, and(r,q)), premise],
    [
      [3, p,      assumption],
      [4, and(r,q),  impel(3,2)]
      [5, q,      andel2(4)]
      [6, r,      andel1(4)]
      [7, and(q,r),      andint(5,6)]
    ],
    [8, imp(p,and(q,r)), impint(3,7)]
].
*/

/* INVALID NON TRIVIAL PROOF WRITTEN FORMAT
PREMISE:
GOAL:
PROOF:

[r,imp(p, imp(r,q))].
imp(p,imp(q,r)).
[
    [1, r,                premise],
    [2, imp(p, imp(r,q)), premise],
    [
      [3, p,      assumption],
      [4, imp(r,q),  impel(3,2)]
      [5, q,      impel(4,1)]
      [6, and(q,r),      andint(5,1)]
    ],
    [7, imp(p,and(q,r)), impint(3,6)]
].
*/

