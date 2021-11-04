/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(cliente), []).

cliente(_):-
	reply_html_page(
		boot5rest,
		[ title('Clientes')],
		[ div(class(container),
		      [ a(href('/'),img(src('/img/house.svg'))),
			\html_requires(css('estiloGeral.css')),
			\html_requires(js('agcm.js')),
			\titulo_da_pagina_cliente('Lista de Clientes'),
			\tabela_de_clientes
		      ])
		]).


titulo_da_pagina_cliente(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_clientes -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_cliente('Clientes', '/cadastrarCliente'),
		  \tabela_cliente]
		)).


cabeca_da_tabela_cliente(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
			a([ href(Link), class('btn btn-primary')],
				'Cadastrar'))
		]) ).

tabela_cliente -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
			[\cabecalho_cliente,
			 tbody(\corpo_tabela_cliente)
			]))).

cabecalho_cliente -->
	html(thead(tr([ th([scope(col)], 'CPF'),
			th([scope(col)], 'Nome'),
			th([scope(col)], 'Endereco'),
			th([scope(col)], 'Telefone'),
			th([scope(col)], 'Bairro'),
			th([scope(col)], 'Identidade'),
			th([scope(col)], 'Complemento'),
			th([scope(col)], 'Compras'),
			th([scope(col)], 'Nº do Vendedor'),
			th([scope(col)], 'Credito'),
			th([scope(col)], 'Valor do Credito'),
			th([scope(col)], 'Acoes')
		      ]))).

corpo_tabela_cliente -->
	{findall( tr([th(scope(row), CPF),
		      td(Nome),
		      td(Endereco),
		      td(Telefone),
		      td(Bairro),
		      td(Identidade),
		      td(Complemento),
		      td(Compras),
		      td(NumVendedor),
		      td(Credito),
		      td(ValorCredito),
		      td(AcoesCliente)]),
		  linha(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
			Compras, NumVendedor, Credito, ValorCredito, AcoesCliente),
		  Linhas)
	},
	html(Linhas).


linha(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
      Compras, NumVendedor, Credito, ValorCredito, AcoesCliente):-
	cliente:cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade,
			Complemento, Compras, NumVendedor, Credito, ValorCredito),
	acoes_cliente(CPF, AcoesCliente).


acoes_cliente(CPF, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
		      href('/cliente/editar/~w' - CPF),
		      'data-toggle'(tooltip)],
		    [ \lapis ]),
		  a([ class('text-danger ms-1'), title('Excluir'),
		      href('/api/v1/cliente/~w' - CPF),
		      onClick("apagar( event,'/cliente' )"),
		      'data-toggle'(tooltip)],
		    [ \lixeira ])].
