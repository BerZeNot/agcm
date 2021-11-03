/* Tabela Item Venda
   itemvenda(IdItemVenda, IdVenda Qtde, Valor).
*/

:- module(itemvenda,[adicionarItemVenda/4,
                     removerItemVenda/1,
                     atualizarItemVenda/4]).

:- use_module(library(persistency)).
:- use_module(chave, []).

:- persistent
    itemvenda(iditemvenda:positive_integer,
	      idvenda:positive_integer,
              qtde:positive_integer,
              valor:float).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).


adicionarItemVenda(IdItemVenda, IdVenda, Qtde, Valor):-
    with_mutex(itemvenda,
	    (chave:pk(itemvenda, IdItemVenda), % obtem a chave primaria
        assert_itemvenda(IdItemVenda, IdVenda, Qtde, Valor))).

%% Remover itemvenda
removerItemVenda(IdItemVenda):-
	with_mutex(itemvenda,
		retract_itemvenda(IdItemVenda, _IdVenda, _Qtde, _Valor)).


%% Atualizar itemvenda

atualizarItemVenda(IdItemVenda, IdVenda, Qtde, Valor):-
	with_mutex(itemvenda,
	    (	retractall_itemvenda(IdItemVenda, _IdVenda, _Qtde, _Valor),
		assert_itemvenda(IdItemVenda, IdVenda, Qtde, Valor))).