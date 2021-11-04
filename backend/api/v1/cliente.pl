/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(cliente), []).

/*
	GET api/v1/cliente/
	Retorna uma lista com todos os clientes.
*/

cliente(get, '', _Pedido):- !,
    envia_tabela_cliente.

/*
	GET /api/v1/cliente/CPF
	Retorna uma lista com o cliente com o CPF informado
	ou erro 404 caso o cliente nao seja encontrado.
*/

cliente(get, AtomCPF, _Pedido):-
    atom_number(AtomCPF, CPF), % o identificador aparece na rota como atomo,
    !,						 % convertendo-o para um numero inteiro.
    envia_tupla_cliente(CPF).


/*
	POST /api/v1/cliente
	Adiciona um novo cliente. Os dados deverao ser
	passados no corpo da requisicao no formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso
	a URL nao tenha sido informada.
*/

cliente(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    insere_tupla_cliente(Dados).


/*
	PUT /api/v1/cliente/CPF
	Atualiza o cliente com o NumCliente informado.
	Os dados deverao ser passados no corpo
	da requisicao no formato JSON.
*/

cliente(put, AtomCPF, Pedido):-
    atom_number(AtomCPF, CPF),
    http_read_json_dict(Pedido, Dados), % leitura do JSON enviado com o Pedido.
    !,
    atualiza_tupla_cliente(Dados, CPF).

/*
	DELETE /api/v1/cliente/CPF
	Apaga o cliente com o CPF informado.
*/

cliente(delete, AtomCPF, _Pedido):-
    atom_number(AtomCPF, CPF),
    !,
    cliente:removerCliente(CPF),
    throw(http_reply(no_content)). % Responde usando o codigo 204 No Content

/*
	Se algo ocorrer de errado, a resposta de
	metodo nao permitido sera retornada.
*/

cliente(Metodo, CPF, _Pedido):-
	% responde com o c�digo 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, CPF))).

/*-----------------------------------------------------------------------------*/

insere_tupla_cliente( _{cpf:CPF,
                        nome:Nome,
                        endereco:Endereco,
                        telefone:Telefone,
                        bairro:Bairro,
                        identidade:Identidade,
                        complemento:Complemento,
                        compras:Compras,
                        numvendedor:NumVendedor,
                        credito:Credito,
                        valorcredito:ValorCredito}):-
    number_string(CPFInt, CPF),
    number_string(TelefoneInt, Telefone),
    number_string(NumVendedorInt, NumVendedor),
    number_string(ValorCreditoNumber, ValorCredito),
    cliente:cadastrarCliente(CPFInt, Nome, Endereco, TelefoneInt, Bairro, Identidade, Complemento,
                             Compras, NumVendedorInt, Credito, ValorCreditoNumber)
    -> envia_tupla_cliente(CPFInt)
    ; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_cliente(_{nome:Nome,
                         endereco:Endereco,
                         telefone:Telefone,
                         bairro:Bairro,
                         identidade:Identidade,
                         complemento:Complemento,
                         compras:Compras,
                         numvededor:NumVendedor,
                         credito:Credito,
                         valorcredito:ValorCredito}, CPF):-
    number_string(TelefoneInt, Telefone),
    number_string(NumVendedorInt, NumVendedor),
    number_string(ValorCreditoNumber, ValorCredito),
    cliente:atualizarCliente(CPF, Nome, Endereco, TelefoneInt, Bairro, Identidade,
                             Complemento, Compras, NumVendedorInt, Credito, ValorCreditoNumber)
    -> envia_tupla_cliente(CPF)
    ; throw(http_reply(not_found(CPF))).


envia_tupla_cliente(CPF):-
    cliente:cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade,
                    Complemento, Compras, NumVendedor, Credito, ValorCredito)
    -> reply_json_dict(_{cpf:CPF,
                         nome:Nome,
                         endereco:Endereco,
                         telefone:Telefone,
                         bairro:Bairro,
                         identidade:Identidade,
                         complemento:Complemento,
                         compras:Compras,
                         numvededor:NumVendedor,
                         credito:Credito,
                         valorcredito:ValorCredito} )
    ; throw(http_reply(not_found)).


envia_tabela_cliente :-
    findall( _{cpf:CPF,
               nome:Nome,
               endereco:Endereco,
               telefone:Telefone,
               bairro:Bairro,
               identidade:Identidade,
               complemento:Complemento,
               compras:Compras,
               numvededor:NumVendedor,
               credito:Credito,
               valorcredito:ValorCredito},
             cliente:cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade,
                             Complemento, Compras, NumVendedor, Credito, ValorCredito),
             Tuplas ),
    reply_json_dict(Tuplas). % envia o JSON para o solicitante
