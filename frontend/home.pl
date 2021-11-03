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
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).





opcoes -->
	html(
		div( class('container'),[
			div( class('row'),[
				div( [class('col card')],a(href('/cliente'),'Gestao de Clientes')),
				div( [class('col card')],a(href('/produtos'),'Gestao de Produtos')),
				div( class('w-100'),''),
				div( [class('col card')],a(href('/gerenciadorVendas'),'Gestao de Vendas')),
				div( [class('col card')],a(href('/fluxodecaixa'),'Fluxo de Caixa'))
			])
		])
	).

%% <div class="container">
%%   <div class="row">
%%     <div class="col">Gestão de Clientes</div>
%%     <div class="col">Gestão de Funcionários</div>
%%     <div class="w-100"></div>
%%     <div class="col">Gestão de Vendas</div>
%%     <div class="col">Fluxo de Caixa</div>
%%   </div>
%% </div>
