/*Tabela de produtos*/

%% produto(Código, Nome, QtdeAtual, QtdMinima,Preco1,Descricao,Preco2).

:- module(
	produto,[
		cadastrarProduto/7,
		removerProduto/1,
		atualizarProduto/7
	]).


%% Importando a biblioteca persistency
:- use_module(library(persistency)).

:- use_module(chave, []).

%% Esquema da relacao
:- persistent
	produto(codigo:positive_integer,
			nome:string,
			qtdeAtual:positive_integer,
			qtdMinima:positive_integer,
			preco1:float,
			descricao:string,
			preco2:float
	).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).



%% Predicado para cadastrar produto
cadastrarProduto(CodProd, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2):-
	chave:pk(produto, CodProd), % obtem a chave primária
	with_mutex(
			produto,
			cadProduto(CodProd, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2)
		).


cadProduto(CodProd, _Nome, _QtdAtual, _QtdMinima, _Preco1, _Descricao, _Preco2):-
	produto:produto(Cod,_,_,_,_,_,_),
	Cod = CodProd,!,fail.

cadProduto(_CodProd, Nome, _QtdAtual, _QtdMinima, _Preco1, _Descricao, _Preco2):-
	produto:produto(_Cod,N,_,_,_,_,_),
	N = Nome,!,fail.

cadProduto(CodProd, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2):-
	produto:assert_produto(CodProd, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2).



%% Remover produto
removerProduto(Id):-
	with_mutex(
		produto,
		remProduto(Id)
	).

remProduto(Id):-
	produto:retractall_produto(Id,_,_,_,_,_,_).



%% Atualizar produto
atualizarProduto(CodProd,NomeNovo, QtdAtual, QtdMinima, Preco1, Descricao, Preco2):-
	with_mutex(
		produto,
		attProduto(CodProd,NomeNovo, QtdAtual, QtdMinima, Preco1, Descricao, Preco2)
	).

attProduto(CodProd,NomeNovo, QtdAtual, QtdMinima, Preco1, Descricao, Preco2):-
	produto:produto(CodProd,_,_,_,_,_,_),
	produto:retractall_produto(CodProd,_,_,_,_,_,_),
	produto:assert_produto(CodProd,NomeNovo, QtdAtual, QtdMinima, Preco1, Descricao, Preco2).