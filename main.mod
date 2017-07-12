module main.
hnf A B :- hstep A C, !, hnf C B.
hnf A A.
dstep A B :- hstep A B.

isa Term TY IE :-
    of Term TY' IE,
    conv TY TY'.

% contextual, transitive, reflexive normal form
nf A B :- dstep A C, !, nf C B.               %nf A A :- printW "HO TROVATO UNA FORMA NORMALE: "  A.
nf A A.
conv A A .
conv A B :- nf A C, nf B C.

isType A col B  :- isType A set   B.
isType A col B  :- isType A prop  B.
isType A set B  :- isType A propS B.
isType A prop B :- isType A propS B.

end

% non contextual, non reflexive, maybe transitive closure
% hstep A B

hstep X N :- locDef X T M , conv M N.
% non contextual, transitive, reflexive normal form

hnf A B :- hstep A C, !, hnf C B.
hnf A A.
% contextual, non reflexive, maybe transitive closure

dstep A B :- hstep A B.

% contextual, transitive, reflexive normal form
nf A B :- dstep A C, !, nf C B.               %nf A A :- printW "HO TROVATO UNA FORMA NORMALE: "  A.
nf A A.
conv A A :- ! .
conv A B :- nf A C, nf B C.

isType A col B  :- isType A set   B.
isType A col B  :- isType A prop  B.
isType A set B  :- isType A props B.
isType A prop B :- isType A props B.

isa Term TY IE :-
    of Term TY' IE,
    conv TY TY'.

%tau Tipo_di_partenza Tipo_di_arrivo Input Output :- fail.

tau' TipoExt ElementoExt Output :-
    trad ElementoExt ElementoInt,
    trad TipoExt TipoInt,
    of ElementoInt Ty int,
    tau Ty TipoInt ElementoInt Output.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Is this ever needed?
%trad (of Aa AA ext)
%     (of(tau A_inferred (TradAA) (TradAa) )
%        (TradAA)
%        int
%     ) :-
%     (trad AA TradAA),
%     (trad Aa TradAa),
%     of (TradAa) A_inferred int.


% [NOTAZIONI]
%   X Xx indicano tipo ed elemento
%   of elemento tipo IE
%   isType tipo Kind IE
%

