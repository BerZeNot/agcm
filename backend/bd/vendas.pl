:- module(vendas,[
	cadastraNovaVenda/5,
	atualizaVenda/5,
	cancelaVenda/1
]).
:- use_module(library(persistency)).
:- use_module(fluxodecaixa).
:- use_module(funcionarios).
:- use_module(chave, []).


:- persistent
   vendas(
          idVenda:positive_integer,
          idVendedor:positive_integer,
		  idCliente:positive_integer,
		  formaPagamento:positive_integer,
		  total:float
		  ).
:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

cadastraNovaVenda(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total):-
       chave:pk(vendas, IdVenda),
       with_mutex(vendas,
	   assert_vendas(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total)).
	   
atualizaVenda(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total):-
       vendas:vendas(IdVenda,_IdVendedor,_FormaPagamento),
	   with_mutex(
	        vendas,
			attVenda(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total)
	   ).
	   
attVenda(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total):-
	vendas:retractall_vendas(IdVenda, _, _, _, _),
	vendas:assert_vendas(IdVenda, IdVendedor, IdCliente, FormaPagamento, Total).
	   
cancelaVenda(IdVenda):-
		with_mutex(vendas,
			retract_vendas(IdVenda, _IdVendedor, _IdCliente, _FormaPagamento, _Total)).

