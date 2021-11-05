/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

%% :- use_module(bd(produto), []). // importa o esquema da tabela produto


home(_):-
	reply_html_page(
		boot5rest,
		[ title('Home')],
		[ div(class(container),
			[ \html_requires(css('homepage.css')),
			  \html_requires(js('agcm.js')),
			  \titulo_da_homepage('Aplicativo de Gestao Comercial Multiplataforma'),
			  \opcoes
			])
		]
	).

titulo_da_homepage(Titulo) -->
	html( div(class('titulo text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


%% Sangria
%% Funcionários
%% Pessoas
opcoes -->
	html(
		div( class('container'),[
			div( class('row'),[
				div( [class('col card clientes')],a(href('/cliente'),'Gestao de Clientes')),
				div( [class('col card produtos')],a(href('/produtos'),'Gestao de Produtos')),
				div( class('w-100'),''),
				div( [class('col card vendas')],a(href('/gerenciadorVendas'),'Gestao de Vendas')),
				div( [class('col card fluxoCaixa')],a(href('/fluxodecaixa'),'Fluxo de Caixa')),
				div( class('w-100'),''),
				div( [class('col card sangria')],a(href('/sangria'),'Gestao de Sangria')),
				div( [class('col card funcionarios')],a(href('/funcionarios'),'Gestao de Funcionarios')),
				div( class('w-100'),''),
				div( [class('col card pessoas')],a(href('/pessoas'),'Gestao de Pessoas'))
			])
		])
	).
