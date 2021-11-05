/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).

:- use_module(bd(funcionarios), []).

funcionarios(_):-
	reply_html_page(
		boot5rest,
		[ title('Funcionarios')],
		[ div(class(container),
		      [ a(href('/'),img(src('/img/house.svg'))),
			\html_requires(css('estiloGeral.css')),
			\html_requires(js('agcm.js')),
			 \titulo_da_pagina_funcionarios('Lista de funcionarios'),
			 \tabela_de_funcionarios
		      ])
		]).


titulo_da_pagina_funcionarios(Titulo) -->
	html( div(class('text-center aligin-items-center w-100'),
			h1('display-3', Titulo))).


tabela_de_funcionarios -->
	html(div(class('container-fluid py-3'),
		[ \cabeca_da_tabela_funcionarios('Funcionarios', '/cadastrarFuncionario'),
		  \tabela_funcionarios
		])
	).


cabeca_da_tabela_funcionarios(Titulo,Link) -->
	html( div(class('d-flex'),
		[ div(class('me-auto p-2'), h2(b(Titulo))),
		  div(class('p-2'),
			a([ href(Link), class('btn btn-primary')],
				'Cadastrar'))
		])
	).

tabela_funcionarios -->
	html(div(class('table-responsive-md'),
		table(class('table table-striped w-100'),
		      [\cabecalho_funcionarios,
		       tbody(\corpo_tabela_funcionarios)
		      ]))).

cabecalho_funcionarios -->
	html(thead(tr([ th([scope(col)], '#'),
			th([scope(col)], 'Nome'),
			th([scope(col)], 'Endereco'),
			th([scope(col)], 'Telefone'),
			th([scope(col)], 'Bairro'),
			th([scope(col)], 'Cpf'),
			th([scope(col)], 'Identidade'),
			th([scope(col)], 'Complemento'),
			th([scope(col)], 'NumFunc'),
			th([scope(col)], 'Admissao'),
			th([scope(col)], 'Carteira de Trabalho'),
			th([scope(col)], 'Ferias'),
			th([scope(col)], 'Horario'),
			th([scope(col)], 'Acoes')
		      ]))).

corpo_tabela_funcionarios -->
	{findall( tr([th(scope(row), Id),
		      td(Nome),
		      td(Endereco),
		      td(Telefone),
		      td(Bairro),
		      td(Cpf),
		      td(Identidade),
		      td(Complemento),
		      td(NumFunc),
		      td(Admissao),
		      td(CarteiraTrabalho),
		      td(Ferias),
		      td(Horario),
		      td(AcoesFuncionarios)
		     ]),
		  linha_funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
				     NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario, AcoesFuncionarios),
		  Linhas)},
	html(Linhas).


linha_funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
		   NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario, AcoesFuncionarios):-
	funcionarios:funcionarios(Id, Nome, Endereco, Telefone, Bairro, Cpf, Identidade, Complemento,
				  NumFunc, Admissao, CarteiraTrabalho, Ferias, Horario),
	acoes_funcionarios(Id, AcoesFuncionarios).


acoes_funcionarios(Id, Campo):-
	Campo = [ a([ class('text-success'), title('Alterar'),
		      href('/funcionarios/editar/~w' - Id),
		      'data-toggle'(tooltip)],
		    [ \lapis ]),
		  a([ class('text-danger ms-1'), title('Excluir'),
		      href('/api/v1/funcionarios/~w' - Id),
		      onClick("apagar( event,'/funcionarios' )"),
		      'data-toggle'(tooltip)],
		    [ \lixeira ])
		].
