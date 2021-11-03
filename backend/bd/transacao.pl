/*Tabela Transação
transacao(Numero, Hora, Valor).
*/

:- module(
		transacao,[executar/2]
	).

:- use_module(library(persistency)).

:- persistent
	transacao(numero:positive_integer,
			  hora: compound,
			  valor:float
			).

:- initialization((db_attach('tbl_transacoes.pl', []),
					at_halt(db_sync(gc(always))))).


executar(Numero, Valor):-
	with_mutex(
		transacao,
		exec(Numero, Valor)
	).


exec(Numero, _Valor):-
	transacao:transacao(NumTransacao, _,_),
	Numero = NumTransacao,!,fail.

%% 10800 = Fuso Horário de São Paulo
exec(Numero, Valor):-
	time_now(10800,Time_Now),
	transacao:assert_transacao(Numero,Time_Now,Valor).


%% Predicado para obter a hora atual no momento da execução
time_now(Fuso, Value):-
	get_time(TimeStamp), 
	stamp_date_time(TimeStamp,DateTime,Fuso),
	date_time_value(time,DateTime,Value).