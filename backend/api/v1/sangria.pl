/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(sangria), []).

/*
	GET api/v1/sangria/
	Retorna uma lista com todos os itens das vendas.
*/

sangria(get, '', _Pedido):- !,
    envia_tabela_sangria. 

/*
	GET /api/v1/sangria/Id
	Retorna uma lista com o item da venda com o Id informado
	ou erro 404 caso o item nao seja encontrado.
*/

sangria(get, AtomId, _Pedido):-
    atom_number(AtomId, Id), % o identificador aparece na rota como atomo,
    !,						 % convertendo-o para um Id inteiro.
    envia_tupla_sangria(Id).


/*
	POST /api/v1/sangria
	Adiciona uma nova sangria. Os dados deverao ser
	passados no corpo da requisicao no formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso
	a URL nao tenha sido informada.
*/

sangria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    insere_tupla_sangria(Dados).


/*
	PUT /api/v1/sangria/Id
	Atualiza a sangria com o Id informado.
	Os dados deverao ser passados no corpo
	da requisicao no formato JSON.
*/

sangria(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    atualiza_tupla_sangria(Dados, Id).

/*
	DELETE /api/v1/sangria/Id
	Apaga o sangria com o Id informado.
*/

sangria(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    sangria:removerSangria(Id),
    throw(http_reply(no_content)). % Responde usando o codigo 204 No Content


/*
	Se algo ocorrer de errado, a resposta de
	metodo nao permitido sera retornada.
*/

sangria(Metodo, Id, _Pedido):-
	% responde com o codigo 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla_sangria( _{valor:Valor,
                        hora:Hora}):-
    number_string(ValorInt,Valor),
    sangria:realizarSangria(Id, ValorInt, Hora)
    -> envia_tupla_sangria(Id)
    ; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_sangria(_{valor:Valor,
                         hora:Hora}, Id):-
    number_string(ValorInt,Valor),
    sangria:atualizarSangria(Id, ValorInt, Hora)
    -> envia_tupla_sangria(Id)
    ; throw(http_reply(not_found(Id))).


envia_tupla_sangria(Id):-
    sangria:sangria(Id, Valor, Hora)
    -> reply_json_dict(_{id:Id,
                         valor:Valor,
                         hora:Hora} )
    ; throw(http_reply(not_found)).


envia_tabela_sangria :-
    findall( _{id:Id,
               valor:Valor,
               hora:Hora},
    sangria:sangria(Id, Valor, Hora),
    Tuplas ),
    reply_json_dict(Tuplas). % envia o JSON para o solicitante
