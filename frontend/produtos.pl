/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(produto), []).

produtos(_):-
	reply_html_page(
		boot5rest,
		[ title('Produtos')],
		[ div(class(container),
			[ 
			  a(href('/'),img(src('/img/house.svg'))),
			  \html_requires(css('estiloGeral.css')),
			  \html_requires(js('agcm.js')),
			  \titulo_da_pagina_produtos('Lista de Produtos'),
			  \tabela_de_produtos
			]) 
		]
	).


titulo_da_pagina_produtos(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_produtos -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_produtos('Produtos', '/cadastrarProduto'),
			\tabela_produtos
		])
	).


cabeca_da_tabela_produtos(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
		  	a([ href(Link), class('btn btn-primary')],
		  		'Cadastrar'))
		])
	).

tabela_produtos -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[
				\cabecalho_produtos,
				tbody(\corpo_tabela_produtos)
			]
		))
	).

cabecalho_produtos -->
	html(thead(tr([ th([scope(col)], '#'),
					th([scope(col)], 'Nome'),
					th([scope(col)], 'Qtd. Atual'),
					th([scope(col)], 'Qtd. Min'),
					th([scope(col)], 'Preco 1'),
					th([scope(col)], 'Descricao'),
					th([scope(col)], 'Preco 2'),
					th([scope(col)], 'Acoes')
				]))).

corpo_tabela_produtos -->
	{
		findall( tr([th(scope(row), Id), 
			td(Nome), 
			td(QtdAtual),
			td(QtdMin),
			td(Preco1),
			td(Descricao),
			td(Preco2),
			td(AcoesProduto)]),
		linha_produto(Id, Nome, QtdAtual, QtdMin, Preco1, Descricao, Preco2,AcoesProduto),
		Linhas)},
		html(Linhas).


linha_produto(Id, Nome, QtdAtual, QtdMin, Preco1, Descricao, Preco2, AcoesProduto):-
	produto:produto(Id, Nome, QtdAtual, QtdMin, Preco1, Descricao, Preco2),
	acoes_produto(Id, AcoesProduto).


acoes_produto(Id, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
				href('/produtos/editar/~w' - Id),
				 'data-toggle'(tooltip)],
				[ \lapis ]),
			  a([ class('text-danger ms-1'), title('Excluir'),
			  	href('/api/v1/produtos/~w' - Id),
				onClick("apagar( event,'/produtos' )"),
				'data-toggle'(tooltip)],
				[ \lixeira ])
			].