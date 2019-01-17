# Guida a un'integrazione felice

## Struttura del progetto

Il progetto si struttura in tre parti principali:

1. `calc`
2. `itp_components`
3. `refinement`
4. `main.elpi`

La prima e l'ultima parte sono quelle "invasive", cioe' sono le parti in cui il
progetto va letteralmente a modificare quanto c'era prima. Le altre due sono
parti modulari che semplicemente si inseriscono a lato e non modificano il
comportamento.

### `calc`

La prima parte riguarda la modifica dei giudizi di tipaggio e di conversione
precedenti. In particolare sono state fatte due cose:

1. modifica di `isa` da giudizio ternario a quaternario (i.e. aggiunta del
   raffinamento)
2. modifica di `conv`, in particolare l'uso di `subst` anziche' avere
   applicazione diretta

La prima modifica e' necessaria per implementare il raffinamento, inoltre e'
stato modificato il corpo delle clausole per gestire metavriabili.

```[prolog]
of (app Lam X) CX (app Lam' X') IE :-
    isa Lam (setPi B C) Lam' IE,
    isa X B X' IE,
    pi x\ (locDecl x B, copy x X') => conv (C x) CX.
```

Come si vede da questo snippet oltre al raffinamento e' stato inserito un
giudizio di conversione, questo per tutti i tipi dipendenti. Il giudizio di
conversione tenta di prevenire la fuoriuscita dal frammento L$_\lambda$. In
particolare, quando abbiamo un tipo dipendente, come in questo caso, il tipo
ritornato e' l'applicazione di un tipo a uno o piu' argomenti, che
tendenzialmente saranno termini arbitrari. Per ovviare a questo si utilizza la
`conv` con apposite ipotesi che serviranno di fatto durante l'unificazione (
`conv` chiamata su termini che contengono meta arriviera' all'unificazione).

In questo caso le ipotesi aggiunte sono di due tipi e vengono sempre inserite
sotto una o piu' quantificazioni universali:

1. dichiarazioni `locDecl ci Ci` che dichiarano che la variabile fresca `ci` e'
   del tipo `Ci`,
2. dichiarazioni di copia di una variabile fresca in una metavariabile i.e.
   `copy ci Xi`.

Le prime servono per eventuali richieste di type inference o type checking sulle
variabili fresche, le seconde vengono usate durante la proiezione.

Lo schema di queste ipotesi e' semplice: per ogni termine a cui un tipo
dipendente sarebbe applicato si crea una variabile fresca, la si tipa del tipo
corretto - eventualmente applicato a variabili fresche che stanno per altre
metavariabili - e si mette un'ipotesi di copia. Queste ipotesi implicano il
giudizio di conversione in cui compare il tipo dipendente applicato solo a
variabili fresche. Questa "tecnica" e' analoga a quella impiegata nel giudizio
`subst` e serve per far rientrare cose esterne al frammento in cose nel
frammento.

La modifica ai giudizi di conversione potrebbe non essere una cosa non
particolarmente utile, bisogna valutare cosa passa per la conversione i.e. se
quando si chiama `conv` e si arriva a quelle regole si hanno solo termini chiusi
(no metavariabili) allora si e' a cavallo, altrimenti si rischia di uscire dal
frammento.

Per l'integrazione di questa parte bisogna letteralmente modificare i giudizi
precedenti.

### `itp_components`

### `refinement`

### `main.elpi`

L'ultima parte riguarda la modifica dei giudizi in `main.elpi`, in particolare

* sospensione del tipaggio nei casi con metavariabile
* aggiunta di definizione con dimostrazione (con e senza script)

Anche questa e' una modifica "invasiva" perche' va a modificare codice
precedente.