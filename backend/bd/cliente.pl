:- module(cliente,[cadastrarCliente/11,
                  removerCliente/1,
                  atualizarCliente/11]).

:- use_module(library(persistency)).

:- persistent
    cliente(cpf:positive_integer,
            nome:string,
            endereco:string,
            telefone:positive_integer,
            bairro:string,
            identidade:string,
            complemento:string,
            compras:string,
            numVendedor:positive_integer,
            credito:string,
            valorcredito:float).

:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

%% Cadastrar cliente
cadastrarCliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
                 Compras, NumVendedor, Credito, ValorCredito):-
	with_mutex(cliente,
                   cadCliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
                              Compras, NumVendedor, Credito, ValorCredito)).

cadCliente(CPF, _Nome, _Endereco, _Telefone, _Bairro, _Identidade, _Complemento,
           _Compras, _NumVendedor, _Credito, _ValorCredito):-
       cliente:cliente(Cpf,_N,_E,_T,_B,_ID,_Compl,_Compr,_NumV,_Cred,_VCred),
       CPF = Cpf,!,fail.

cadCliente(_CPF, _Nome, _Endereco, _Telefone, _Bairro, Identidade, _Complemento,
           _Compras, _NumVendedor, _Credito, _ValorCredito):-
	cliente:cliente(_Cpf,_N,_E,_T,_B,ID,_Compl,_Compr,_NumV,_Cred,_VCred),
	Identidade = ID,!,fail.

cadCliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
           Compras, NumVendedor, Credito, ValorCredito):-
	cliente:assert_cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
                               Compras, NumVendedor, Credito, ValorCredito).


%% Remover cliente
removerCliente(CPF):-
	with_mutex(
		cliente,
		remCliente(CPF)).

remCliente(CPFToRemove):-
	cliente:retractall_cliente(CPFToRemove,_,_,_,_,_,_,_,_,_,_).


%% Atualizar cliente
atualizarCliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
                 Compras, NumVendedor, Credito, ValorCredito):-
	with_mutex(
		cliente,
		attCliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
                           Compras, NumVendedor, Credito, ValorCredito)).

attCliente(CPFFix, Nome, Endereco, Telefone, Bairro, _Identidade, Complemento,
           Compras, NumVendedor, Credito, ValorCredito):-
       cliente:cliente(CPFFix, _Nome, _Endereco, _Telefone, _Bairro, IdentidadeBase, _Complemento,
                       _Compras, _NumVendedor, _Credito, _ValorCredito),
       cliente:retractall_cliente(CPFFix,_,_,_,_,_,_,_,_,_,_),
       cliente:assert_cliente(CPFFix, Nome, Endereco, Telefone, Bairro, IdentidadeBase, Complemento,
                              Compras, NumVendedor, Credito, ValorCredito).
