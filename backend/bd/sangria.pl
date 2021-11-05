/* Tabela Sangria:
   sangria(Numero, Valor, Hora).

*Sangria: Caso no qual o dinheiro em caixa � retirado
mesmo enquanto o caixa esta em opera��o.
*/

:- module(sangria,[realizarSangria/3,
		   atualizarSangria/3,
		   removerSangria/1
		   ]).
:- use_module(library(persistency)).
:- use_module(chave, []).
:- persistent
    sangria(id:positive_integer,
            valor:float,
            hora:string).
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

%% Realizacao de uma nova sangria
realizarSangria(Id, Valor, Hora):-
    with_mutex(sangria,
	    (chave:pk(sangria, Id), % obtem a chave primaria
	     assert_sangria(Id, Valor, Hora))).

%% Remover sangria
removerSangria(Id):-
	with_mutex(sangria,
		retract_sangria(Id, _Valor, _Hora)).


%% Atualizar sangria

atualizarSangria(Id, Valor, Hora):-
	with_mutex(sangria,
	    (	retractall_sangria(Id, _Valor, _Hora),
		assert_sangria(Id, Valor, Hora))).

