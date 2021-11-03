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
	GET /api/v1/sangria/Numero
	Retorna uma lista com o item da venda com o Numero informado
	ou erro 404 caso o item nao seja encontrado.
*/

sangria(get, AtomNumero, _Pedido):-
    atom_number(AtomNumero, Numero), % o identificador aparece na rota como atomo,
    !,						 % convertendo-o para um numero inteiro.
    envia_tupla_sangria(Numero).


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
	PUT /api/v1/sangria/Numero
	Atualiza a sangria com o Numero informado.
	Os dados deverao ser passados no corpo
	da requisicao no formato JSON.
*/

sangria(put, AtomNumero, Pedido):-
    atom_number(AtomNumero, Numero),
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    atualiza_tupla_sangria(Dados, Numero).

/*
	DELETE /api/v1/sangria/Numero
	Apaga o itemvenda com o Numero informado.
*/

sangria(delete, AtomNumero, _Pedido):-
    atom_number(AtomNumero, Numero),
    !,
    sangria:removerSangria(Numero),
    throw(http_reply(no_content)). % Responde usando o codigo 204 No Content


/*
	Se algo ocorrer de errado, a resposta de
	metodo nao permitido sera retornada.
*/

sangria(Metodo, Numero, _Pedido):-
	% responde com o codigo 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Numero))).


insere_tupla_sangria( _{numero:Numero,
                        valor:Valor,
                        hora:Hora}):-
    sangria:realizarSangria(Numero, Valor, Hora)
    -> envia_tupla_sangria(Numero)
    ; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_sangria(_{valor:Valor,
                         hora:Hora}, Numero):-
    sangria:atualizarSangria(Numero, Valor, Hora)
    -> envia_tupla_sangria(Numero)
    ; throw(http_reply(not_found(Numero))).


envia_tupla_sangria(Numero):-
    sangria:sangria(Numero, Valor, Hora)
    -> reply_json_dict(_{numero:Numero,
                         valor:Valor,
                         hora:Hora} )
    ; throw(http_reply(not_found)).


envia_tabela_sangria :-
    findall( _{numero:Numero,
               valor:Valor,
               hora:Hora},
    sangria:sangria(Numero, Valor, Hora),
    Tuplas ),
    reply_json_dict(Tuplas). % envia o JSON para o solicitante
