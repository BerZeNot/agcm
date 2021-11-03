:- module(fluxodecaixa,[
	insere/3,
	remove/1,
	atualiza/3
]).
:- use_module(library(persistency)).
:- persistent
   fluxodecaixa(id:positive_integer,
	            numeroTransacao:positive_integer,
				valor:positive_integer).

carrega_tab(ArqTabela):- 
	db_attach(ArqTabela, []).

insere(Id, NumeroTransacao, Valor):-
	   chave:pk(fluxodecaixa, Id), % obtem a chave primária
	   with_mutex(fluxodecaixa,
                  assert_fluxodecaixa(Id, NumeroTransacao, Valor)).

remove(Id):-
		with_mutex(fluxodecaixa,
			retract_fluxodecaixa(Id, _NumeroTransacao , _Valor)
		).

atualiza(Id, NumeroTransacao, Valor):-
	fluxodecaixa:fluxodecaixa(Id, _, _),
	with_mutex(fluxodecaixa,
			(retractall_fluxodecaixa(Id, _NumeroTransacao, _Valor),
			 assert_fluxodecaixa(Id, NumeroTransacao, Valor)
	)).