:- module(funcionarios,[cadastrarFuncionario/13,
			removerFuncionario/1,
			atualizarFuncionario/13]).
:- use_module(library(persistency)).
:- persistent
   funcionarios(id:positive_integer,
		nome:string,
		endereco:string,
		telefone:positive_integer,
		bairro:string,
		cpf:positive_integer,
		identidade:string,
		complemento:string,
		numFunc:positive_integer,
		admissao:string,
		carteiraTrabalho:string,
		ferias:string,
		horario:string).

carrega_tab(ArqTabela):-
	db_attach(ArqTabela, []).

cadastrarFuncionario(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
		     NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario):-
	chave:pk(funcionarios, Id), % obtem a chave primária
	with_mutex(funcionarios,
		   assert_funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
				       NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario)).


removerFuncionario(Id):-
	funcionarios:funcionarios(Id, _, _, _, _, _, _, _, _, _, _, _, _),
	with_mutex(funcionarios,
		   retract_funcionarios(Id, _Nome, _Endereco, _Telefone, _Bairro, _Cpf, _Identidade,
					_Complemento, _NumFunc, _Admissao, _CarteiraTrabalho, _Ferias, _Horario)).


atualizarFuncionario(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
		     NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario):-
	with_mutex(funcionarios,
		   ( retractall_funcionarios(Id, _Nome, _Endereco, _Telefone, _Bairro, _Cpf, _Identidade, _Complemento,
					     _NumFunc, _Admissao, _CarteiraTrabalho, _Ferias, _Horario),
		     assert_funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
					 NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario))).

