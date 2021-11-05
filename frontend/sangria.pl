/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(sangria), []).

sangria(_):-
	reply_html_page(
		boot5rest,
		[ title('Sangria')],
		[ div(class(container),
		      [ a(href('/'),img(src('/img/house.svg'))),
			\html_requires(css('estiloGeral.css')),
			\html_requires(js('agcm.js')),
			\titulo_da_pagina_sangria('Lista de Sangrias'),
			\tabela_de_sangria])
		]).


titulo_da_pagina_sangria(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_sangria -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_sangria('Sangria', '/cadastrarSangria'),
		  \tabela_sangria]
		)).


cabeca_da_tabela_sangria(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
			a([ href(Link), class('btn btn-primary')],
				'Realizar'))
		]) ).

tabela_sangria -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[\cabecalho_sangria,
			 tbody(\corpo_tabela_sangria)
			]))).

cabecalho_sangria -->
	html(thead(tr([ th([scope(col)], '#'),
			th([scope(col)], 'Valor'),
			th([scope(col)], 'Hora'),
			th([scope(col)], 'Acoes')
		      ]))).

corpo_tabela_sangria -->
	{findall( tr([th(scope(row), Id),
		      td(Valor),
		      td(Hora),
		      td(AcoesSangria)]),
		  linha_sangria(Id, Valor, Hora, AcoesSangria),
		  Linhas)
	},
	html(Linhas).


linha_sangria(Id, Valor, Hora, AcoesSangria):-
	sangria:sangria(Id, Valor, Hora),
	acoes_sangria(Id, AcoesSangria).


acoes_sangria(Id, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
		      href('/sangria/editar/~w' - Id),
		      'data-toggle'(tooltip)],
		    [ \lapis ]),
		  a([ class('text-danger ms-1'), title('Excluir'),
		      href('/api/v1/sangria/~w' - Id),
		      onClick("apagar( event,'/sangria' )"),
		      'data-toggle'(tooltip)],
		    [ \lixeira ])].