% http_handler, http_reply_file
:- use_module(library(http/http_dispatch)).

% http:location
:- use_module(library(http/http_path)).

:- ensure_loaded(projeto(caminhos)).

/*************************
*  Rotas do Servidor Web *
**************************/

:- multifile http:location/3.
:- dynamic   http:location/3.

/* http:location(Apelido,Rota,Opções)
		Apelido é como será chamada uma Rota do servidor
		Os apelidos css, icons e js já estão definidos na
		biblioteca http/http_server_files, os demais precisam
		ser definidos.
*/

http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).
http:location(webfonts, root(webfonts), []).


/*************************
*       Tratadores       *
**************************/

% Recursos estáticos
:- http_handler( css(.),
		serve_files_in_directory(dir_css), [prefix]).

:- http_handler( img(.),
		serve_files_in_directory(dir_img), [prefix]).

:- http_handler( js(.),
		serve_files_in_directory(dir_js), [prefix]).

:- http_handler( webfonts(.),
		serve_files_in_directory(dir_webfonts), [prefix]).



% Rotas do Frontend

% Página inicial
:- http_handler( root(.), home	, []).


%%  --- PRODUTOS ---
%% A página de listar todos os produtos
:- http_handler( root(produtos), produtos, []).

%% A página de cadastro de novos produtos
:- http_handler( root(cadastrarProduto), cadastroProduto, []).

%% A página de edição dos dados de um produto cadastrado
:- http_handler( root(produtos/editar/Id), editar_produto(Id), []).

%% %%  --- PESSOAS ---
%% %% A página de listar todos as pessoas
:- http_handler( root(pessoas), pessoas, []).

%% %% A página de cadastro de novas pessoas
:- http_handler( root(cadastrarPessoa), cadastroPessoa, []).

%% %% A página de edição dos dados de uma pessoa
:- http_handler( root(pessoas/editar/CPF), editar_pessoa(CPF), []).


%% %%  --- CLIENTES ---
%% %% A página de listar todos as pessoas
:- http_handler( root(cliente), cliente, []).

%% %% A página de cadastro de novas cliente
:- http_handler( root(cadastrarCliente), cadastroCliente, []).

%% %% A página de edição dos dados de um cliente
:- http_handler( root(cliente/editar/CPF), editar_cliente(CPF), []).


%% %%  --- VENDAS ---
%% %% A página de listar todos de vendas
:- http_handler( root(gerenciadorVendas), gerenciadorVendas, []).


%% %%  --- FLUXODECAIXA ---
%% %% A página de listar todos os fluxos de caixa
:- http_handler( root(fluxodecaixa), fluxodecaixa, []).

%% %% A página de cadastro de novos fluxos de caixa
:- http_handler( root(cadastrarFluxoDeCaixa), cadastroFluxoDeCaixa, []).

%% %% A página de edição dos dados de um fluxo de caixa
:- http_handler( root(fluxodecaixa/editar/Id), editar_fluxodecaixa(Id), []).


%% %%  --- SANGRIA ---
%% %% A página de listar todas as sangrias
:- http_handler( root(sangria), sangria, []).

%% %% A página de realizacao de novas sangrias
:- http_handler( root(cadastrarSangria), realizarSangria, []).

%% %% A página de edição dos dados de uma sangria
:- http_handler( root(sangria/editar/Id), editar_sangria(Id), []).


%% %%  --- ITEMVENDA ---
%% %% A página de listar todos os itens de vendas
:- http_handler( root(itemvenda), itemvenda, []).

%% %% A página de cadastro de novos itens de vendas
:- http_handler( root(cadastrarItemVenda), cadastroItemVenda, []).

%% %% A página de edição dos dados de um item de uma venda
:- http_handler( root(itemvenda/editar/IdItemVenda), editar_itemvenda(IdItemVenda), []).

%% %%  --- Funcionário ---
:- http_handler( root(funcionarios), funcionarios, []).

%% %% A página de cadastro de novos funcionarios
:- http_handler( root(cadastrarFuncionario), cadastroFuncionario, []).

%% %% A página de edição dos dados de um funcionario
:- http_handler( root(funcionarios/editar/Id), editar_funcionario(Id), []).



%% Rotas da API
:- http_handler( api1(produtos/Id), produtos(Metodo, Id),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(pessoas/CPF), pessoas(Metodo, CPF),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(cliente/CPF), cliente(Metodo, CPF),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(itemvenda/IdItemVenda), itemvenda(Metodo, IdItemVenda),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(sangria/Id), sangria(Metodo, Id),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(fluxodecaixa/Id), fluxodecaixa(Metodo, Id),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(vendas/IdVenda), vendas(Metodo, IdVenda),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).

:- http_handler( api1(funcionarios/Id), funcionarios(Metodo, Id),
				[ method(Metodo),
				  methods([ get, post, put, delete]) ]).
