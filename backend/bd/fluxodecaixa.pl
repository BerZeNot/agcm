:- module(fluxodecaixa,[
	cadastrarFluxoDeCaixa/3,
	removerFluxoDeCaixa/1,
	atualizarFluxoDeCaixa/3
]).
:- use_module(library(persistency)).
:- use_module(chave, []).
:- persistent
   fluxodecaixa(id:positive_integer,
		numeroTransacao:positive_integer,
		valor:float).

carrega_tab(ArqTabela):-
	db_attach(ArqTabela, []).

cadastrarFluxoDeCaixa(Id, NumeroTransacao, Valor):-
	   chave:pk(fluxodecaixa, Id), % obtem a chave primária
	   with_mutex(fluxodecaixa,
                  assert_fluxodecaixa(Id, NumeroTransacao, Valor)).

removerFluxoDeCaixa(Id):-
		with_mutex(fluxodecaixa,
			retract_fluxodecaixa(Id, _NumeroTransacao , _Valor)
		).

atualizarFluxoDeCaixa(Id, NumeroTransacao, Valor):-
	fluxodecaixa:fluxodecaixa(Id, _, _),
	with_mutex(fluxodecaixa,
			(retractall_fluxodecaixa(Id, _NumeroTransacao, _Valor),
			 assert_fluxodecaixa(Id, NumeroTransacao, Valor)
	)).
