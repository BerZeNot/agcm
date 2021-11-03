/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(pessoa), []).

/*
	GET api/v1/pessoas/
	Retorna uma lista com todas as pessoas.
*/

pessoas(get, '', _Pedido):- !,
	envia_tabela_pessoas.


/*
	GET /api/v1/pessoas/CPF
	Retorna uma lista com os dados da pessoa com o CPF informado
	ou erro 404 caso a pessoa não seja encontrada.
*/

pessoas(get, AtomCPF, _Pedido):-
	atom_number(AtomCPF, CPF), % o identificador aparece na rota como átomo,
	!,						 % converta-o para um número inteiro.
	envia_tupla_pessoas(CPF).


/*
	POST /api/v1/pessoas
	Adiciona uma nova pessoa. Os dados deverão ser 
	passados no corpo da requisição no formato JSON. 
	Um erro 400 (BAD REQUEST) deve ser retornado caso 
	a URL não tenha sido informada.
*/

pessoas(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	insere_tupla_pessoas(Dados).


/*
	PUT /api/v1/pessoas/CPF
	Atualiza os dados da pessoa com o CPF informado. 
	Os dados deverão ser passados no corpo 
	da requisição no formato JSON.
*/

pessoas(put, AtomCPF, Pedido):-
	atom_number(AtomCPF, CPF),
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	atualiza_tupla_pessoas(Dados, CPF).


/*
	DELETE /api/v1/pessoas/CPF
	Apaga os dados da pessoa com o CPF informado.
*/

pessoas(delete, AtomCPF, _Pedido):-
	atom_number(AtomCPF, CPF),
	!,
	pessoa:removerPessoa(CPF),
	throw(http_reply(no_content)). % Responde usando o código 204 No Content

/* 
	Se algo ocorrer de errado, a resposta de 
	método não permitido será retornada.
*/

pessoas(Metodo, CPF, _Pedido):-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, CPF))).

insere_tupla_pessoas( _{nome:Nome,
				endereco:Endereco,
				telefone:Telefone,
				bairro:Bairro,
				cpf:CPF,
				identidade:Identidade,
				complemento:Complemento}):-
	atom_number(Telefone,TelefoneInt),
	atom_number(CPF,CPFInt),
	pessoa:cadastrarPessoa(Nome, Endereco, TelefoneInt, Bairro, CPFInt, Identidade, Complemento)
	-> envia_tupla_pessoas(CPFInt)
	; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_pessoas(_{nome:Nome,
				endereco:Endereco,
				telefone:Telefone,
				bairro:Bairro,
				complemento:Complemento}, CPFAtual):-
	atom_number(Telefone,TelefoneInt),
	pessoa:atualizarPessoa(Nome, Endereco, TelefoneInt, Bairro, CPFAtual, _Identidade, Complemento)
	-> envia_tupla_pessoas(CPFAtual)
	; throw(http_reply(not_found(CPFAtual))).

envia_tupla_pessoas(CPF):-
	pessoa:pessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento)
	-> reply_json_dict(_{nome:Nome,
				endereco:Endereco,
				telefone:Telefone,
				bairro:Bairro,
				cpf:CPF,
				identidade:Identidade,
				complemento:Complemento})
	; throw(http_reply(not_found)).

envia_tabela_pessoas :-
	findall( _{nome:Nome,
				endereco:Endereco,
				telefone:Telefone,
				bairro:Bairro,
				cpf:CPF,
				identidade:Identidade,
				complemento:Complemento},
	pessoa:pessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento),
	Tuplas ),
	reply_json_dict(Tuplas). % envia o JSON para o solicitante