/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(pessoa), []).


pessoas(_):-
	reply_html_page(
		boot5rest,
		[ title('Pessoas')],
		[ div(class(container),
			[ a(href('/'),img(src('/img/house.svg'))),
			  \html_requires(css('estiloGeral.css')),
			  \html_requires(js('agcm.js')),
			  \titulo_da_pagina_pessoas('Lista de Pessoas'),
			  \tabela_de_pessoas
			]) 
		]
	).


titulo_da_pagina_pessoas(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_pessoas -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_pessoas('Pessoas', '/cadastrarPessoa'),
			\tabela_pessoas
		])
	).


cabeca_da_tabela_pessoas(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
		  	a([ href(Link), class('btn btn-primary')],
		  		'Cadastrar'))
		])
	).

tabela_pessoas -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[
				\cabecalho_pessoas,
				tbody(\corpo_tabela_pessoas)
			]
		))
	).

cabecalho_pessoas -->
	html(thead(tr([	th([scope(col)], 'Nome'),
					th([scope(col)], 'Endereco'),
					th([scope(col)], 'Telefone'),
					th([scope(col)], 'Bairro'),
					th([scope(col)], 'CPF'),
					th([scope(col)], 'Identidade'),
					th([scope(col)], 'Complemento')
				]))).

corpo_tabela_pessoas -->
	{
		findall( tr([th(scope(row), Nome), 
			td(Endereco), 
			td(Telefone),
			td(Bairro),
			td(CPF),
			td(Identidade),
			td(Complemento),
			td(AcoesPessoa)]),
		linha(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento, AcoesPessoa),
		Linhas)},
		html(Linhas).


linha(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento, AcoesPessoa):-
	pessoa:pessoa(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento),
	acoes_pessoa(CPF, AcoesPessoa).


acoes_pessoa(CPF, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
				href('/pessoas/editar/~w' - CPF),
				 'data-toggle'(tooltip)],
				[ \lapis ]),
			  a([ class('text-danger ms-1'), title('Excluir'),
			  	href('/api/v1/pessoas/~w' - CPF),
				onClick("apagar( event,'/pessoas' )"),
				'data-toggle'(tooltip)],
				[ \lixeira ])
			].