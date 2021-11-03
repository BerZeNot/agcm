:- module(funcionarios,[
	cadastraFuncionario/13,
	removeFuncionario/1,
	atualizaFuncionario/13
]).
:- use_module(library(persistency)).
:- persistent
   funcionarios(id:positive_integer,
	            nome:string,
				endereco:string,
				telefone:string,
				bairro:string,
				cpf:string,
				identidade:string,
				complemento: string,
				numFunc: positive_integer,
				admissao: string,
				carteiraTrabalho: string,
				ferias: string,
				horario: string
				
    ).

carrega_tab(ArqTabela):- 
	db_attach(ArqTabela, []).

cadastraFuncionario(
	   Id,
	   Nome,
	   Endereco,
	   Telefone,
	   Bairro,
	   Cpf,
	   Identidade,
	   Complemento,
	   NumFunc,
	   Admissao,
	   CarteiraTrabalho,
	   Ferias,
	   Horario):-
	   chave:pk(funcionarios, Id), % obtem a chave primária
       with_mutex(funcionarios,
                  assert_funcionarios(Id,
					                  Nome,
									 Endereco,
									 Telefone,
									 Bairro,
									 Cpf,
									 Identidade,
									 Complemento,
									 NumFunc,
									 Admissao,
									 CarteiraTrabalho,
									 Ferias,
									 Horario)
	   ).
	   
	   
removeFuncionario(Id):-
	    funcionarios:funcionarios(Id, _, _, _, _, _, _, _, _, _, _, _, _),
		with_mutex(funcionarios,
			retract_funcionarios(Id, _Nome, _Endereco, _Telefone, _Bairro, _Cpf, _Identidade, _Complemento, _NumFunc, _Admissao, _CarteiraTrabalho, _Ferias, _Horario)
		).
		
		

atualizaFuncionario(Id,
	    Nome,
		Endereco,
		Telefone,
		Bairro,
		Cpf,
		Identidade,
		Complemento,
		NumFunc,
		Admissao,
		CarteiraTrabalho,
		Ferias,
		Horario):-
	with_mutex(funcionarios,
			( retractall_funcionarios(Id,
				                      _Nome,
									  _Endereco,
									  _Telefone,
									  _Bairro,
									  _Cpf,
									  _Identidade,
									  _Complemento,
									  _NumFunc,
									  _Admissao,
									  _CarteiraTrabalho,
									  _Ferias,
									  _Horario),
			assert_funcionarios( Id,
				                 Nome,
								 Endereco,
								 Telefone,
								 Bairro,
								 Cpf,
								 Identidade,
								 Complemento,
								 NumFunc,
								 Admissao,
								 CarteiraTrabalho,
								 Ferias,
								 Horario)
			)).

