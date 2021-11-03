/*Tabela Pessoas
pessoa(Nome, Endereço, Telefone, Bairro, CPF, Identidade, Complemento).

*/

:- module(
	pessoa,[
		cadastrarPessoa/7,
		removerPessoa/1,
		atualizarPessoa/7
	]).


%% Importando a biblioteca persistency
:- use_module(library(persistency)).

%% Esquema da relação
:- persistent
	 pessoa(nome:string,
	 		endereco:string,
			telefone:positive_integer,
			bairro:string,
			cpf:positive_integer,
			identidade:string,
			complemento:string
	).


:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).


%% Cadastrar pessoa
cadastrarPessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento):-
	with_mutex(
		pessoa,
		cadPessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento)
	).


cadPessoa(_Nome, _Endereco, _Telefone, _Bairro, CPF, _Identidade, _Complemento):-
	pessoa:pessoa(_N,_E,_T,_B,Cpf,_ID,_Compl),
	CPF = Cpf,!,fail.

cadPessoa(_Nome, _Endereco, _Telefone, _Bairro, _CPF, Identidade, _Complemento):-
	pessoa:pessoa(_N,_E,_T,_B,_Cpf,ID,_Compl),
	Identidade = ID,!,fail.

cadPessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento):-
	pessoa:assert_pessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento).

%% Remover pessoa
removerPessoa(CPF):-
	with_mutex(
		pessoa,
		remPessoa(CPF)
	).

remPessoa(CPFToRemove):-
	pessoa:retractall_pessoa(_,_,_,_,CPFToRemove,_,_).


%% Atualizar nome
atualizarPessoa(Nome,Endereco, Telefone, Bairro, CPF, Identidade, Complemento):-
	with_mutex(
		pessoa,
		attPessoa(Nome, Endereco, Telefone, Bairro, CPF, Identidade, Complemento)
	).

attPessoa(Nome, Endereco, Telefone, Bairro, CPFFix, _Identidade, Complemento):-
	pessoa:pessoa(_Nome, _Endereco, _Telefone, _Bairro, CPFFix, IdentidadeBase, _Complemento),
	pessoa:retractall_pessoa(_,_,_,_,CPFFix,_,_),
	pessoa:assert_pessoa(Nome, Endereco, Telefone, Bairro, CPFFix, IdentidadeBase, Complemento).