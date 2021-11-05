/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(vendas), []).

/*
	GET api/v1/vendas/
	Retorna uma lista com todas as vendas.
*/

vendas(get, '', _Pedido):- !,
	envia_tabela_vendas.


/*
	GET /api/v1/vendas/ID
	Retorna uma lista com os dados da vendas com o ID informado
	ou erro 404 caso a vendas não seja encontrada.
*/

vendas(get, AtomId, _Pedido):-
	atom_number(AtomId, Id), % o identificador aparece na rota como atomo,
	!,						 % converta-o para um número inteiro.
	envia_tupla_vendas(Id).


/*
	POST /api/v1/vendas
	Adiciona uma nova vendas. Os dados deverão ser 
	passados no corpo da requisição no formato JSON. 
	Um erro 400 (BAD REQUEST) deve ser retornado caso 
	a URL não tenha sido informada.
*/

vendas(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	insere_tupla_vendas(Dados).


/*
	PUT /api/v1/vendas/ID
	Atualiza os dados da vendas com o ID informado. 
	Os dados deverão ser passados no corpo 
	da requisição no formato JSON.
*/

vendas(put, AtomId, Pedido):-
	atom_number(AtomId, Id),
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	atualiza_tupla_vendas(Dados, Id).


/*
	DELETE /api/v1/vendas/ID
	Apaga os dados da vendas com o ID informado.
*/

vendas(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdVenda),
	vendas:cancelaVenda(IdVenda) -> throw(http_reply(no_content)) % responde usando o código 204 No Content
    ; throw(http_reply(not_found(AtomId))). % Se houver um erro responde usando o código 404 Not found

/* 
	Se algo ocorrer de errado, a resposta de 
	Metodo não permitido sera retornada.
*/

vendas(Metodo, Id, _Pedido):-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, Id))).

insere_tupla_vendas( _{ codVendedor:IdVendedorString,
	                    codCliente:IdClienteString,
						formaPagamento:FormaPagamentoString,
						total:TotalString }):-
    number_string(TotalFloat, TotalString),	
	number_string(IdVendedorInt, IdVendedorString),
	number_string(IdClienteInt, IdClienteString),
	number_string(FormaPagamentoInt, FormaPagamentoString),

	vendas:cadastraNovaVenda(IdVenda, IdVendedorInt, IdClienteInt, FormaPagamentoInt, TotalFloat)
	-> envia_tupla_vendas(IdVenda)
	; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_vendas(_{ codVendedor:IdVendedorString,
	                    codCliente:IdClienteString,
						formaPagamento:FormaPagamentoString,
						total:TotalString }, IdVendaString):-
	number_string(TotalFloat, TotalString),	
	number_string(IdVendedorInt, IdVendedorString),
	number_string(IdVendaInt, IdVendaString),
	number_string(IdClienteInt, IdClienteString),
	number_string(FormaPagamentoInt, FormaPagamentoString),
	vendas:atualizaVenda(IdVendaInt, IdVendedorInt, IdClienteInt, FormaPagamentoInt, TotalFloat)
	-> envia_tupla_vendas(IdVendaInt)
	; throw(http_reply(not_found(IdVendaString))).

envia_tupla_vendas(IdVenda):-
	vendas:vendas(IdVenda, IdVendedor, IdCliente, FormaPagamento, TotalFloat)
	-> reply_json_dict(_{ idVenda:IdVenda,
	                      idVendedor:IdVendedor,
						  idCliente:IdCliente,
						  formaPagamento:FormaPagamento,
						  total: TotalFloat })
	; throw(http_reply(not_found(IdVenda))).

envia_tabela_vendas :-
	findall( _{ idVenda:IdVenda,
	            idVendedor:IdVendedor,
				idCliente:IdCliente,
				formaPagamento:FormaPagamento,
				total: TotalFloat },
	vendas:vendas(IdVenda, IdVendedor, IdCliente, FormaPagamento, TotalFloat),
	Tuplas ),
	reply_json_dict(Tuplas). % envia o JSON para o solicitante