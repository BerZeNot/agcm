/* http_parameters */
:- use_module(library(http/http_parameters)).
/* http_reply */
:- use_module(library(http/http_header)).
/* reply_json_dict */
:- use_module(library(http/http_json)).

:- use_module(bd(funcionarios), []).

/*
	GET api/v1/funcionarios/
	Retorna uma lista com todas as funcionarios.
*/

funcionarios(get, '', _Pedido):- !,
	envia_tabela_funcionarios.


/*
	GET /api/v1/funcionarios/Id
	Retorna uma lista com os dados da funcionarios com o Id informado
	ou erro 404 caso a funcionarios não seja encontrada.
*/

funcionarios(get, AtomId, _Pedido):-
	atom_number(AtomId, Id), % o identificador aparece na rota como atomo,
	!,						 % converta-o para um número inteiro.
	envia_tupla_funcionarios(Id).


/*
	POST /api/v1/funcionarios
	Adiciona uma nova funcionarios. Os dados deverão ser
	passados no corpo da requisição no formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso
	a URL não tenha sido informada.
*/

funcionarios(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	insere_tupla_funcionarios(Dados).


/*
	PUT /api/v1/funcionarios/Id
	Atualiza os dados da funcionarios com o Id informado.
	Os dados deverão ser passados no corpo
	da requisição no formato JSON.
*/

funcionarios(put, AtomId, Pedido):-
	atom_number(AtomId, Id),
	http_read_json_dict(Pedido, Dados), % Lê o JSON enviado com o Pedido.
	!,
	atualiza_tupla_funcionarios(Dados, Id).


/*
	DELETE /api/v1/funcionarios/Id
	Apaga os dados da funcionarios com o Id informado.
*/

funcionarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
	funcionarios:removerFuncionario(Id) -> throw(http_reply(no_content)) % responde usando o código 204 No Content caso n houver erros
    ; throw(http_reply(not_found(AtomId))). % Senao responde usando o código 404 Not found

/*
	Se algo ocorrer de errado, a resposta de
	Metodo não permitido sera retornada.
*/

funcionarios(Metodo, Id, _Pedido):-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, Id))).

insere_tupla_funcionarios( _{nome:Nome,
                             endereco:Endereco,
                             telefone:Telefone,
                             bairro:Bairro,
                             cpf:Cpf,
                             identidade:Identidade,
                             complemento:Complemento,
                             numFunc:NumFunc,
                             admissao:Admissao,
                             carteiraTrabalho:CarteiraTrabalho,
                             ferias:Ferias,
                             horario:Horario }):-
	number_string(TelefoneInt, Telefone),
	number_string(CpfInt, Cpf),
        number_string(NumFuncInt, NumFunc),
	funcionarios:cadastrarFuncionario(Id, Nome, Endereco, TelefoneInt, Bairro, CpfInt, Identidade, Complemento,
					  NumFuncInt, Admissao, CarteiraTrabalho, Ferias, Horario)
	-> envia_tupla_funcionarios(Id)
	; throw(http_reply(bad_request('Dados inconsistentes'))).


atualiza_tupla_funcionarios(_{nome:Nome,
                              endereco:Endereco,
                              telefone:Telefone,
                              bairro:Bairro,
                              cpf:Cpf,
                              identidade:Identidade,
                              complemento:Complemento,
                              numFunc:NumFunc,
                              admissao:Admissao,
                              carteiraTrabalho:CarteiraTrabalho,
                              ferias:Ferias,
                              horario:Horario }, Id):-
	number_string(TelefoneInt, Telefone),
	number_string(CpfInt, Cpf),
        number_string(NumFuncInt, NumFunc),
	funcionarios:atualizarFuncionario(Id, Nome, Endereco, TelefoneInt, Bairro, CpfInt, Identidade, Complemento,
					  NumFuncInt, Admissao, CarteiraTrabalho, Ferias, Horario)
	-> envia_tupla_funcionarios(Id)
	; throw(http_reply(not_found(Id))).

envia_tupla_funcionarios(Id):-
	funcionarios:funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
				  NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario)
	-> reply_json_dict(_{nome:Nome,
                             endereco:Endereco,
                             telefone:Telefone,
			     bairro:Bairro,
                             cpf:Cpf,
                             identidade:Identidade,
                             complemento:Complemento,
                             numFunc:NumFunc,
                             admissao:Admissao,
                             carteiraTrabalho:CarteiraTrabalho,
                             ferias:Ferias,
                             horario:Horario })
	; throw(http_reply(not_found(Id))).

envia_tabela_funcionarios :-
	findall( _{id:Id,
                   nome:Nome,
                   endereco:Endereco,
                   telefone:Telefone,
                   bairro:Bairro,
                   cpf:Cpf,
                   identidade:Identidade,
                   complemento:Complemento,
                   numFunc:NumFunc,
                   admissao:Admissao,
                   carteiraTrabalho:CarteiraTrabalho,
                   ferias:Ferias,
                   horario:Horario },
		 funcionarios:funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade,
					   Complemento, NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario),
		 Tuplas ),
	reply_json_dict(Tuplas). % envia o JSON para o solicitante
