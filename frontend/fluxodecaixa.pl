/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(fluxodecaixa), []).

fluxodecaixa(_):-
	reply_html_page(
		boot5rest,
		[ title('Fluxo de Caixa')],
		[ div(class(container),
			[ a(href('/'),img(src('/img/house.svg'))),
			  \html_requires(css('estiloGeral.css')),
			  \html_requires(js('agcm.js')),
			  \titulo_da_pagina_fluxodecaixa('Lista de Fluxos de Caixa'),
			  \tabela_de_fluxodecaixa
			])
		]
	).


titulo_da_pagina_fluxodecaixa(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_fluxodecaixa -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_fluxodecaixa('Fluxo de Caixa', '/fluxodecaixa'),
			\tabela_fluxodecaixa
		])
	).


cabeca_da_tabela_fluxodecaixa(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
			a([ href(Link), class('btn btn-primary')],
				'Cadastrar'))
		])
	).

tabela_fluxodecaixa -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[
				\cabecalho_tabela_fluxodecaixa,
				tbody(\corpo_tabela_fluxodecaixa)
			]
		))
	).

cabecalho_tabela_fluxodecaixa -->
	html(thead(tr([ th([scope(col)], '#'),
					th([scope(col)], 'NumeroTransacao'),
					th([scope(col)], 'Valor')
				]))).

corpo_tabela_fluxodecaixa -->
	{
		findall( tr([
                      th(scope(row), Id),
			          td(NumeroTransacao),
			          td(Valor),
					  td(Acoes)
                    ]),
		linha_fluxodecaixa(Id, NumeroTransacao, Valor, Acoes),
	    Linhas)
	},
	html(Linhas).


linha_fluxodecaixa(Id, NumeroTransacao, Valor, Acoes):-
	fluxodecaixa:fluxodecaixa(Id, NumeroTransacao, Valor),
	acoes_linha_fluxodecaixa(Id, Acoes).


acoes_linha_fluxodecaixa(Id, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
				href('/produto/editar/~w' - Id),
				 'data-toggle'(tooltip)],
				[ \lapis ]),
			  a([ class('text-danger ms-1'), title('Excluir'),
				href('/api/v1/fluxodecaixa/~w' - Id),
				onClick("apagar( event,'/fluxodecaixa' )"),
				'data-toggle'(tooltip)],
				[ \lixeira ])
			].