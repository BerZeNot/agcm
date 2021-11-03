/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(itemvenda), []).

itemvenda(_):-
	reply_html_page(
		boot5rest,
		[ title('ItemVenda')],
		[ div(class(container),
		      [ a(href('/'),img(src('/img/house.svg'))),
			\html_requires(css('estiloGeral.css')),
			\html_requires(js('agcm.js')),
			\titulo_da_pagina_itemvenda('Lista de itens de vendas'),
			\tabela_de_itemvenda])
		]).


titulo_da_pagina_itemvenda(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_itemvenda -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_itemvenda('ItemVenda', '/cadastrarItemVenda'),
		  \tabela_itemvenda]
		)).


cabeca_da_tabela_itemvenda(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
			a([ href(Link), class('btn btn-primary')],
				'Cadastrar'))
		]) ).

tabela_itemvenda -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[\cabecalho_itemvenda,
			 tbody(\corpo_tabela_itemvenda)
			]))).

cabecalho_itemvenda -->
	html(thead(tr([ th([scope(col)], 'Codigo'),
			th([scope(col)], 'Quantidade'),
			th([scope(col)], 'Valor'),
			th([scope(col)], 'Acoes')
		      ]))).

corpo_tabela_itemvenda -->
	{findall( tr([th(scope(row), CodItemVenda),
		      td(Qtde),
		      td(Valor),
		      td(AcoesItemVenda)]),
		  linha(CodItemVenda, Qtde, Valor, AcoesItemVenda),
		  Linhas)
	},
	html(Linhas).


linha(CodItemVenda, Qtde, Valor, AcoesItemVenda):-
	itemvenda:itemvenda(CodItemVenda, Qtde, Valor),
	acoes_itemvenda(CodItemVenda, AcoesItemVenda).


acoes_itemvenda(CodItemVenda, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
		      href('/itemvenda/editar/~w' - CodItemVenda),
		      'data-toggle'(tooltip)],
		    [ \lapis ]),
		  a([ class('text-danger ms-1'), title('Excluir'),
		      href('/api/v1/itemvenda/~w' - CodItemVenda),
		      onClick("apagar( event,'/itemvenda' )"),
		      'data-toggle'(tooltip)],
		    [ \lixeira ])].