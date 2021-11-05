/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(fluxodecaixa), []).

/*
	GET api/v1/fluxodecaixa/
	Retorna uma lista com todas as fluxodecaixa.
*/

fluxodecaixa(get, '', _Pedido):- !,
	envia_tabela_fluxodecaixa.


/*
	GET /api/v1/fluxodecaixa/ID
	Retorna uma lista com os dados da fluxodecaixa com o ID informado
	ou erro 404 caso a fluxodecaixa não seja encontrada.
*/

fluxodecaixa(get, AtomId, _Pedido):-
	atom_number(AtomId, Id), % o identificador aparece na rota como atomo,
	!,						 % converta-o para um número inteiro.
	envia_tupla_fluxodecaixa(Id).


/*
	POST /api/v1/fluxodecaixa
	Adiciona uma nova fluxodecaixa. Os dados deverão ser
	passados no corpo da requisição no formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso
	a URL não tenha sido informada.
*/

fluxodecaixa(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	insere_tupla_fluxodecaixa(Dados).


/*
	PUT /api/v1/fluxodecaixa/ID
	Atualiza os dados da fluxodecaixa com o ID informado.
	Os dados deverão ser passados no corpo
	da requisição no formato JSON.
*/

fluxodecaixa(put, AtomId, Pedido):-
	atom_number(AtomId, Id),
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	atualiza_tupla_fluxodecaixa(Dados, Id).


/*
	DELETE /api/v1/fluxodecaixa/ID
	Apaga os dados da fluxodecaixa com o ID informado.
*/

fluxodecaixa(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
	fluxodecaixa:removerFluxoDeCaixa(Id) -> throw(http_reply(no_content)) % responde usando o código 204 No Content
    ; throw(http_reply(not_found(AtomId))). % Se houver um erro responde usando o código 404 Not found

/*
	Se algo ocorrer de errado, a resposta de
	Metodo não permitido sera retornada.
*/

fluxodecaixa(Metodo, Id, _Pedido):-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, Id))).

insere_tupla_fluxodecaixa( _{numerotransacao:NumeroTransacao,
			     valor:Valor}):-
	number_string(NumeroTransacaoInt, NumeroTransacao),
	number_string(ValorInt, Valor),
	fluxodecaixa:cadastrarFluxoDeCaixa(Id, NumeroTransacaoInt, ValorInt)
	-> envia_tupla_fluxodecaixa(Id)
	; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_fluxodecaixa(_{numerotransacao:NumeroTransacao,
			      valor:Valor}, Id):-
	number_string(NumeroTransacaoInt, NumeroTransacao),
	number_string(ValorInt, Valor),
	fluxodecaixa:atualizarFluxoDeCaixa(Id, NumeroTransacaoInt, ValorInt)
	-> envia_tupla_fluxodecaixa(Id)
	; throw(http_reply(not_found(Id))).

envia_tupla_fluxodecaixa(Id):-
	fluxodecaixa:fluxodecaixa(Id, NumeroTransacao, Valor)
	-> reply_json_dict(_{numeroTransacao:NumeroTransacao,
			     valor:Valor})
	; throw(http_reply(not_found(Id))).

envia_tabela_fluxodecaixa :-
	findall( _{id:Id,
		   numeroTransacao:NumeroTransacao,
		   valor:Valor},
	fluxodecaixa:fluxodecaixa(Id, NumeroTransacao, Valor),
	Tuplas ),
	reply_json_dict(Tuplas). % envia o JSON para o solicitante
