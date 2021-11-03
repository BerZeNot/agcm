/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(produto), []).

/*
	GET api/v1/produtos/
	Retorna uma lista com todos os produtos.
*/

produtos(get, '', _Pedido):- !,
	envia_tabela.


/*
	GET /api/v1/produtos/Id
	Retorna uma lista com o produto com o Id informado
	ou erro 404 caso o produto não seja encontrado.
*/

produtos(get, AtomId, _Pedido):-
	atom_number(AtomId, Id), % o identificador aparece na rota como átomo,
	!,						 % converta-o para um número inteiro.
	envia_tupla(Id).


/*
	POST /api/v1/produtos
	Adiciona um novo produto. Os dados deverão ser 
	passados no corpo da requisição no formato JSON. 
	Um erro 400 (BAD REQUEST) deve ser retornado caso 
	a URL não tenha sido informada.
*/

produtos(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	insere_tupla(Dados).


/*
	PUT /api/v1/produtos/Id
	Atualiza o produto com o Id informado. 
	Os dados deverão ser passados no corpo 
	da requisição no formato JSON.
*/

produtos(put, AtomId, Pedido):-
	atom_number(AtomId, Id),
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	atualiza_tupla(Dados, Id).


/*
	DELETE /api/v1/produtos/Id
	Apaga o produto com o Id informado.
*/

produtos(delete, AtomId, _Pedido):-
	atom_number(AtomId, Id),
	!,
	produto:removerProduto(Id),
	throw(http_reply(no_content)). % Responde usando o código 204 No Content

/* 
	Se algo ocorrer de errado, a resposta de 
	método não permitido será retornada.
*/

produtos(Metodo, Id, _Pedido):-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, Id))).

insere_tupla( _{nome:Nome,
				qtdeAtual:QtdAt,
				qtdMinima:QtdMin,
				preco1:Preco1,
				descricao:Descr,
				preco2:Preco2}):-
	atom_number(QtdAt,QtdAtInt),
	atom_number(QtdMin,QtdMinInt),
	atom_number(Preco1,Preco1Int),
	atom_number(Preco2,Preco2Int),
	produto:cadastrarProduto(Id, Nome, QtdAtInt, QtdMinInt, Preco1Int, Descr,Preco2Int)
	-> envia_tupla(Id)
	; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla(_{nome:Nome,
				qtdeAtual:QtdAt,
				qtdMinima:QtdMin,
				preco1:Preco1,
				descricao:Descr,
				preco2:Preco2}, Id):-
	atom_number(QtdAt,QtdAtInt),
	atom_number(QtdMin,QtdMinInt),
	atom_number(Preco1,Preco1Int),
	atom_number(Preco2,Preco2Int),
	produto:atualizarProduto(Id, Nome, QtdAtInt, QtdMinInt, Preco1Int, Descr,Preco2Int)
	-> envia_tupla(Id)
	; throw(http_reply(not_found(Id))).

envia_tupla(Id):-
	produto:produto(Id, Nome, QtdAt, QtdMin, Preco1, Descr,Preco2)
	-> reply_json_dict(_{nome:Nome,
						qtdeAtual:QtdAt,
						qtdMinima:QtdMin,
						preco1:Preco1,
						descricao:Descr,
						preco2:Preco2})
	; throw(http_reply(not_found)).

envia_tabela :-
	findall( _{id:Id,
			   nome:Nome,
			   qtdeAtual:QtdAt,
			   qtdMinima:QtdMin,
			   preco1:Preco1,
			   descricao:Descr,
			   preco2:Preco2},
	produto:produto(Id, Nome, QtdAt, QtdMin, Preco1, Descr,Preco2),
	Tuplas ),
	reply_json_dict(Tuplas). % envia o JSON para o solicitante