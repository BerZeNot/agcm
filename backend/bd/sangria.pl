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
    sangria(numero:positive_integer,
            valor:float,
            hora:string).
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

%% Realizacao de uma nova sangria
realizarSangria(Numero, Valor, Hora):-
    with_mutex(sangria,
	    (chave:pk(sangria, Numero), % obtem a chave primaria
	     assert_sangria(Numero, Valor, Hora))).

%% Remover sangria
removerSangria(Numero):-
	with_mutex(sangria,
		retract_sangria(Numero, _Valor, _Hora)).


%% Atualizar sangria

atualizarSangria(Numero, Valor, Hora):-
	with_mutex(sangria,
	    (	retractall_sangria(Numero, _Valor, _Hora),
		assert_sangria(Numero, Valor, Hora))).



/*
carrega_tab(ArqTabela):-
	db_attach(ArqTabela, []).

realizarSangria(Numero, Valor):-
	with_mutex(sangria,
		   sang(Numero, Valor)).

sang(Numero, _Valor):-
	sangria:sangria(NumTransacao, _,_),
	Numero = NumTransacao,!,fail.

% 10800 = Fuso Horario de Sao Paulo
sang(Numero, Valor):-
	hora(10800, Hora),
	sangria:assert_sangria(Numero, Valor, Hora).


% Predicado para obter a hora atual no momento da realizacao da sangria
hora(Value, Fuso):-
	get_time(TimeStamp),
	stamp_date_time(TimeStamp, DateTime, Fuso),
	date_time_value(time, Value, DateTime).

confirmaSangria(Numero, Valor, Hora):-
	sangria:sangria,
	write((Numero, Valor, Hora)), nl,fail.

alterarSangria(Numero, Valor, Hora):-
    with_mutex(sangria,
               ( retractall_sangria(Numero, _Valor, _Hora),
                 assert_sangria(Numero, Valor, Hora)) ).

removerSangria(Numero):-
	with_mutex(sangria,
		remSangria(Numero)).

remSangria(SangriaRemoval):-
	sangria:sangria(Numero,_,_),
	SangriaRemoval \= Numero,fail.

remSangria(SangriaRemoval):-
	sangria:retractall_sangria(SangriaRemoval,_,_).
*/
