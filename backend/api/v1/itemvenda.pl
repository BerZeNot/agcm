/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(itemvenda), []).

/*
	GET api/v1/itemvenda/
	Retorna uma lista com todos os itens das vendas.
*/

itemvenda(get, '', _Pedido):- !,
    envia_tabela_itemvenda.

/*
	GET /api/v1/itemvenda/IdItemVenda
	Retorna uma lista com o item da venda com o IdItemVenda informado
	ou erro 404 caso o item nao seja encontrado.
*/

itemvenda(get, AtomIdItemVenda, _Pedido):-
    atom_number(AtomIdItemVenda, IdItemVenda), % o identificador aparece na rota como atomo,
    !,						 % convertendo-o para um numero inteiro.
    envia_tupla_itemvenda(IdItemVenda).


/*
	POST /api/v1/itemvenda
	Adiciona um novo item venda. Os dados deverao ser
	passados no corpo da requisicao no formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso
	a URL nao tenha sido informada.
*/

itemvenda(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    insere_tupla_itemvenda(Dados).


/*
	PUT /api/v1/itemvenda/CodItemVenda
	Atualiza o itemvenda com o CodItemVenda informado.
	Os dados deverao ser passados no corpo
	da requisicao no formato JSON.
*/

itemvenda(put, AtomIdItemVenda, Pedido):-
    atom_number(AtomIdItemVenda, IdItemVenda),
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    atualiza_tupla_itemvenda(Dados, IdItemVenda).

/*
	DELETE /api/v1/itemvenda/IdItemVenda
	Apaga o itemvenda com o IdItemVenda informado.
*/

itemvenda(delete, AtomIdItemVenda, _Pedido):-
    atom_number(AtomIdItemVenda, IdItemVenda),
    !,
    itemvenda:removerItemVenda(IdItemVenda),
    throw(http_reply(no_content)). % Responde usando o codigo 204 No Content

/*
	Se algo ocorrer de errado, a resposta de
	metodo nao permitido sera retornada.
*/

itemvenda(Metodo, IdItemVenda, _Pedido):-
	% responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, IdItemVenda))).


insere_tupla_itemvenda( _{iditemvenda:IdItemVenda,
                          idvenda:IdVenda,
                          qtde:Qtde,
                          valor:Valor}):-
    itemvenda:adicionarItemVenda(IdItemVenda, IdVenda, Qtde, Valor)
    -> envia_tupla_itemvenda(IdItemVenda)
    ; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_itemvenda(_{idvenda:IdVenda,
                           qtde:Qtde,
                           valor:Valor}, IdItemVenda):-
    itemvenda:atualizarItemVenda(IdItemVenda, IdVenda, Qtde, Valor)
    -> envia_tupla_itemvenda(IdItemVenda)
    ; throw(http_reply(not_found(IdItemVenda))).


envia_tupla_itemvenda(IdItemVenda):-
    itemvenda:itemvenda(IdItemVenda, IdVenda, Qtde, Valor)
    -> reply_json_dict(_{iditemvenda:IdItemVenda,
                         idvenda:IdVenda,
                         qtde:Qtde,
                         valor:Valor} )
    ; throw(http_reply(not_found)).


envia_tabela_itemvenda :-
    findall( _{iditemvenda:IdItemVenda,
               idvenda:IdVenda,
               qtde:Qtde,
               valor:Valor},
    itemvenda:itemvenda(IdItemVenda, IdVenda, Qtde, Valor),
    Tuplas ),
    reply_json_dict(Tuplas). % envia o JSON para o solicitante